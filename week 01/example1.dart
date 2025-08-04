import 'package:flutter/material.dart';

void main() => runApp(const CounterApp());

class CounterApp extends StatefulWidget {
  const CounterApp({super.key});

  @override
  State<CounterApp> createState() => _CounterAppState();
}

class _CounterAppState extends State<CounterApp> {
  int count = 0;

  void increment() {
    setState(() {
      count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Counter Example')),
        body: Center(
          child: Text('Count: $count', style: const TextStyle(fontSize: 30)),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: increment,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

