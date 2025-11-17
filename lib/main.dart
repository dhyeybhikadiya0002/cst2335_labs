import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CST2355 - Lab 1',
        debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Flutter Demo Home Page')
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
  // 1) _counter uses var, initialized to 0.0
  var _counter = 0.0;
  // 3) shared font size variable
  var myFontSize = 30.0;

  void _incrementCounter() {
    setState(() {

      _counter++;
    });
  }
  // 4) slider handler
  void setNewValue(double v) => setState(() => myFontSize = v);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 3) remove const and use TextStyle
            Text(
              'You have pushed the button this many times:',
              style: TextStyle(fontSize: myFontSize),
              textAlign: TextAlign.center,
            ),
            Text(
              myFontSize.toString(), // show slider value with decimals
              style: TextStyle(
                fontSize: myFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            // 4) Slider updates myFontSize via setNewValuew
            Slider(
              value: myFontSize,
              min: 10,
              max: 72,
              onChanged: setNewValue,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
