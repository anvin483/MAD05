import 'package:flutter/material.dart';

void main() => runApp(const LayoutDemo());

class LayoutDemo extends StatelessWidget {
  const LayoutDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Row & Column Example")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Top", style: TextStyle(fontSize: 24)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Left"),
                  SizedBox(width: 20),
                  Text("Right"),
                ],
              ),
              const Text("Bottom", style: TextStyle(fontSize: 24)),
            ],
          ),
        ),
      ),
    );
  }
}
