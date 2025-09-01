import 'package:flutter/material.dart';

void main() => runApp(QuizApp());

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(primarySwatch: Colors.indigo),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/quiz': (context) => QuizPage(),
        '/result': (context) => ResultPage(),
      },
    );
  }
}

// ---------- Data ----------

class Question {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String imageUrl;

  Question({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.imageUrl,
  });
}

List<Question> questions = [
  Question(
    question: "What is the capital of France?",
    options: ["Paris", "London", "Berlin", "Rome"],
    correctIndex: 0,
    imageUrl: "https://cdn-icons-png.flaticon.com/512/197/197560.png",
  ),
  Question(
    question: "What is 2 + 2?",
    options: ["3", "4", "5", "6"],
    correctIndex: 1,
    imageUrl: "https://cdn-icons-png.flaticon.com/512/3004/3004642.png",
  ),
  Question(
    question: "Which planet is known as the Red Planet?",
    options: ["Earth", "Venus", "Mars", "Jupiter"],
    correctIndex: 2,
    imageUrl: "https://cdn-icons-png.flaticon.com/512/3212/3212608.png",
  ),
];

// ---------- Home Page ----------

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quiz App")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              "https://cdn-icons-png.flaticon.com/512/3135/3135715.png",
              width: 100,
            ),
            SizedBox(height: 20),
            Text(
              "Welcome to the Quiz!",
              style: TextStyle(fontSize: 22),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.play_arrow),
              label: Text("Start Quiz"),
              onPressed: () {
                Navigator.pushNamed(context, '/quiz');
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- Quiz Page ----------

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestion = 0;
  int score = 0;
  List<int> selectedAnswers = [];

  void _nextQuestion(int selectedIndex) {
    if (selectedIndex == questions[currentQuestion].correctIndex) {
      score++;
    }
    selectedAnswers.add(selectedIndex);
    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
      });
    } else {
      Navigator.pushReplacementNamed(context, '/result',
          arguments: {'score': score, 'answers': selectedAnswers});
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestion];

    return Scaffold(
      appBar: AppBar(title: Text("Question ${currentQuestion + 1}")),
      body: GestureDetector(
        onHorizontalDragEnd: (_) {},
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Image.network(question.imageUrl, width: 80),
              SizedBox(height: 20),
              Text(
                question.question,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ...List.generate(question.options.length, (index) {
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.circle_outlined),
                    title: Text(question.options[index]),
                    onTap: () => _nextQuestion(index),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------- Result Page ----------

class ResultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final score = args['score'] as int;
    final answers = args['answers'] as List<int>;

    int correct = score;
    int total = questions.length;
    int incorrect = total - correct;

    return Scaffold(
      appBar: AppBar(title: Text("Your Score")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text("You scored $score / $total!",
                  style: TextStyle(fontSize: 24)),
              SizedBox(height: 40),
              Text("Summary", style: TextStyle(fontSize: 20)),
              SizedBox(height: 20),
              _buildBar("Correct", correct, Colors.green),
              _buildBar("Incorrect", incorrect, Colors.red),
              SizedBox(height: 30),
              ElevatedButton.icon(
                icon: Icon(Icons.replay),
                label: Text("Restart Quiz"),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/');
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBar(String label, int value, Color color) {
    return Row(
      children: [
        SizedBox(width: 80, child: Text(label)),
        Expanded(
          child: Container(
            height: 20,
            color: color.withOpacity(0.2),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: value / questions.length,
              child: Container(color: color),
            ),
          ),
        ),
        SizedBox(width: 10),
        Text("$value"),
      ],
    );
  }
}
