import 'package:flutter/material.dart';

void main() {
  runApp(LayoutDemoApp());
}

class LayoutDemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Layout Demo',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: InteractiveLayoutScreen(),
    );
  }
}

class InteractiveLayoutScreen extends StatefulWidget {
  @override
  _InteractiveLayoutScreenState createState() => _InteractiveLayoutScreenState();
}

class _InteractiveLayoutScreenState extends State<InteractiveLayoutScreen> {
  bool _showSidebar = true;

  final Map<String, Color> _boxColors = {
    'Box 1': Colors.orange,
    'Box 2': Colors.blue,
    'Box 3': Colors.green,
  };

  void _toggleSidebar() {
    setState(() {
      _showSidebar = !_showSidebar;
    });
  }

  // Navigate to detail page with fade transition
  void _navigateToDetail(BuildContext context, String label, Color color) {
    Navigator.of(context).push(_createRoute(label, color));
  }

  Route _createRoute(String label, Color color) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => DetailScreen(label: label, color: color),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Fade transition
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Interactive Flutter Layout'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleSidebar,
        tooltip: _showSidebar ? 'Hide Sidebar' : 'Show Sidebar',
        child: Icon(_showSidebar ? Icons.arrow_back_ios : Icons.arrow_forward_ios),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 100,
              width: double.infinity,
              color: Colors.teal.shade300,
              alignment: Alignment.center,
              child: Text(
                'Header Section',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: _showSidebar ? 100 : 0,
                    color: Colors.teal.shade100,
                    alignment: Alignment.center,
                    child: _showSidebar
                        ? RotatedBox(
                            quarterTurns: 3,
                            child: Text('Sidebar', style: TextStyle(fontSize: 18)),
                          )
                        : null,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      color: Colors.teal.shade50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Main Content',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: _boxColors.entries.map((entry) {
                              return GestureDetector(
                                onTap: () => _navigateToDetail(context, entry.key, entry.value),
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: entry.value,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 6,
                                        offset: Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    entry.key,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 60,
              width: double.infinity,
              color: Colors.teal.shade700,
              alignment: Alignment.center,
              child: Text(
                'Footer Section',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final String label;
  final Color color;

  const DetailScreen({required this.label, required this.color, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$label Details'),
        backgroundColor: color,
      ),
      body: Center(
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [Shadow(blurRadius: 4, color: Colors.black54, offset: Offset(2, 2))],
            ),
          ),
        ),
      ),
    );
  }
}
