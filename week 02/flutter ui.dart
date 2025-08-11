import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Common Widgets Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Common Widgets'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Settings action
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Welcome to Flutter UI',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),

            // Input field
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your name',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 20),

            // Buttons in a Row with SnackBars
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Submit button pressed')),
                    );
                  },
                  child: Text('Submit'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Cancel button pressed')),
                    );
                  },
                  icon: Icon(Icons.cancel),
                  label: Text('Cancel'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Image from network
            Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[300],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  'https://static0.gamerantimages.com/wordpress/wp-content/uploads/2025/01/blue-lock-1-1.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Card widget
            Card(
              elevation: 4,
              child: ListTile(
                leading: Icon(Icons.info, color: Colors.blue),
                title: Text('Flutter is awesome!'),
                subtitle: Text('Build beautiful apps easily.'),
              ),
            ),
            SizedBox(height: 20),

            // Container with text and icon
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.blue[50],
              child: Row(
                children: [
                  Icon(Icons.thumb_up, color: Colors.blue),
                  SizedBox(width: 10),
                  Expanded(child: Text('Like this UI example')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
