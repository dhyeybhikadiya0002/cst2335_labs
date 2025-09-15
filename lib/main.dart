import 'package:flutter/material.dart';

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

  // Start with question mark (300x300 shown via sizing)
  String _imageSource = 'Images/question-mark.png';
  String _imageLabel = 'Question mark icon';

  @override
  void dispose() {
    _loginCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    final pwd = _passCtrl.text;

    // Rule:
    // - If password == "QWERTY123" => light bulb
    // - Else if password != "ASDF" => stop sign
    // - Else (password == "ASDF") => question mark
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
              // Login name
              TextField(
                controller: _loginCtrl,
                decoration: const InputDecoration(
                  labelText: 'Login name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              // Password (obscured)
              TextField(
                controller: _passCtrl,
                obscureText: true, // required by lab
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              // Login button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onLoginPressed,
                  child: const Text('Login'),
                ),
              ),
              const SizedBox(height: 16),
              // Image 300x300 with Semantics
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
