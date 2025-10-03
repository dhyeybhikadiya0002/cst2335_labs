import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _loginCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _prefs = EncryptedSharedPreferences();

  String _imageSource = 'Images/question-mark.png';
  String _imageLabel = 'Question mark icon';

  @override
  void initState() {
    super.initState();
    // Load saved creds at startup. If found, fill fields and show SnackBar.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final u = await _prefs.getString('username');
      final p = await _prefs.getString('password');
      if (u != null && p != null && u.isNotEmpty && p.isNotEmpty) {
        _loginCtrl.text = u;
        _passCtrl.text = p;
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Loaded saved login and password')),
        );
      }
    });
  }

  @override
  void dispose() {
    _loginCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _onLoginPressed() async {
    final pwd = _passCtrl.text;

    // Image logic unchanged
    setState(() {
      if (pwd == 'QWERTY123') {
        _imageSource = 'Images/idea.png';
        _imageLabel = 'Light bulb icon';
      } else if (pwd != 'ASDF') {
        _imageSource = 'Images/stop.png';
        _imageLabel = 'Stop sign icon';
      } else {
        _imageSource = 'Images/question-mark.png';
        _imageLabel = 'Question mark icon';
      }
    });

    // Ask to save creds
    final choice = await showDialog<_SaveChoice>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Save login?'),
        content: const Text('Save your username and password for next time?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, _SaveChoice.no),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, _SaveChoice.yes),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (!mounted) return;

    if (choice == _SaveChoice.yes) {
      await _prefs.setString('username', _loginCtrl.text);
      await _prefs.setString('password', _passCtrl.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Credentials saved')),
      );
    } else if (choice == _SaveChoice.no) {
      await _prefs.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saved data cleared')),
      );
    }

    // Extra SnackBar echoing the password (kept from your code)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Password entered: $pwd')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _loginCtrl,
                decoration: const InputDecoration(
                  labelText: 'Login name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onLoginPressed,
                  child: const Text('Login'),
                ),
              ),
              const SizedBox(height: 16),
              Semantics(
                label: _imageLabel,
                child: Image.asset(
                  _imageSource,
                  width: 300,
                  height: 300,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _SaveChoice { yes, no }
