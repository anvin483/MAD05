import 'package:flutter/material.dart';

void main() => runApp(const InputDemo());

class InputDemo extends StatefulWidget {
  const InputDemo({super.key});

  @override
  State<InputDemo> createState() => _InputDemoState();
}

class _InputDemoState extends State<InputDemo> {
  final TextEditingController controller = TextEditingController();
  String displayText = '';

  void updateText() {
    setState(() {
      displayText = controller.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Input Example')),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(labelText: "Enter something"),
              ),
              ElevatedButton(onPressed: updateText, child: const Text("Show")),
              const SizedBox(height: 20),
              Text(displayText, style: const TextStyle(fontSize: 24)),
            ],
          ),
        ),
      ),
    );
  }
}
