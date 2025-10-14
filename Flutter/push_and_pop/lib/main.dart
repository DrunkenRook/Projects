import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Push/Pop Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MyHomePage(
        title: 'Flutter Push/Pop Home Page',
        counter: _counter,
        onIncrement: _incrementCounter,
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({super.key, required this.counter, required this.onIncrement});
  //make the counter and increment required to allow for carried increment through push/pop

  final int counter;//make the variabes finals so they cannot be changed(try to change for updating on third page)
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second Page')),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,//makes the buttons evenly spaced on a row
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('You have pushed the button this many times:'),
              Text(
                '$counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
          ElevatedButton(
            child: const Text('Third Page'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ThirdPage(
                  counter: counter,
                  onIncrement: onIncrement,
                        )),
              );
            },
          ),
          ElevatedButton(
              child: const Text('Go Back'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
        ],
      ),
    );
  }
}

class ThirdPage extends StatelessWidget {
  const ThirdPage({super.key, required this.counter, required this.onIncrement});

  final int counter;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Third Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Go Back'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onIncrement,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title, required this.counter, required this.onIncrement});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final int counter;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(title),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('You have pushed the button this many times:'),
              Text(
                '$counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
          ElevatedButton(
            child: const Text('Push to Second Page'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SecondPage(
                    counter: counter,
                    onIncrement: onIncrement,
                        )),
              );
            },
          ),
          ElevatedButton(
            child: const Text('Push to Third Page'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ThirdPage(
                    counter: counter,
                    onIncrement: onIncrement,
                        )),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onIncrement,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
