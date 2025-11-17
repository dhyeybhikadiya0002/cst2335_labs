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

  // TEST W2-01:
  // • Initial image must be question-mark.png.
  // • Label should read "Question mark icon".
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

    /*
      TEST W2-02: pwd == "QWERTY123"
        → image = idea.png, label = "Light bulb icon"
        → SnackBar shows "Password entered: QWERTY123"

      TEST W2-03: pwd == "ASDF"
        → image = question-mark.png

      TEST W2-04: any other password (wrong, empty, random)
        → image = stop.png

      TEST W2-05:
        • SnackBar should always show the entered password.
        • No crash with empty password.
    */

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
      // TEST W2-06:
      // • Check that SnackBar appears after every Login press.
      // • Works for empty, correct, wrong passwords.
      SnackBar(content: Text('Password entered: $pwd')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        // TEST W2-00:
        // • App loads correctly.
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // LOGIN FIELD TESTS
              // TEST W2-L1:
              // • Type text, delete it, type long text → no crash.
              // • Does NOT affect image logic.
              TextField(
                controller: _loginCtrl,
                decoration: const InputDecoration(
                  labelText: 'Login name',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),

              // PASSWORD FIELD TESTS
              // TEST W2-P1:
              // • obscureText must hide password input.
              // • Enter empty, ASDF, QWERTY123, wrong text → each triggers different image logic.
              TextField(
                controller: _passCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),

              // BUTTON TESTS
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onLoginPressed,
                  child: const Text('Login'),
                  // TEST W2-B1:
                  // • Single tap → triggers logic.
                  // • Double-tap → SnackBar appears twice, app must not crash.
                  // • Works even if login name is empty.
                ),
              ),

              const SizedBox(height: 16),

              // IMAGE + SEMANTICS TESTS
              // TEST W2-I1:
              // • Correct image shown based on password logic.
              // • Semantics label updates each time.
              // • Image should update immediately after pressing Login.
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
