import 'package:flutter/material.dart';

void main() {
  runApp(const BMICalculatorApp());
}

class BMICalculatorApp extends StatelessWidget {
  const BMICalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const InputScreen(),
    );
  }
}

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  String? _errorMessage;

  // Calculate BMI and navigate to ResultScreen
  void _calculateBMI() {
    final heightStr = _heightController.text.trim();
    final weightStr = _weightController.text.trim();

    if (heightStr.isEmpty || weightStr.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter both height and weight.';
      });
      return;
    }

    final height = double.tryParse(heightStr);
    final weight = double.tryParse(weightStr);

    if (height == null || weight == null || height <= 0 || weight <= 0) {
      setState(() {
        _errorMessage = 'Please enter valid positive numbers.';
      });
      return;
    }

    setState(() => _errorMessage = null);

    final bmi = weight / ((height / 100) * (height / 100));

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ResultScreen(bmi: bmi)),
    );
  }

  void _clearFields() {
    _heightController.clear();
    _weightController.clear();
    setState(() => _errorMessage = null);
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BMI Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Enter your height (cm) and weight (kg):',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _heightController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Height (cm)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.height),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _weightController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Weight (kg)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.monitor_weight),
              ),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[400],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 14),
                      textStyle: const TextStyle(fontSize: 18)),
                  onPressed: _clearFields,
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.calculate),
                  label: const Text('Calculate'),
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 14),
                      textStyle: const TextStyle(fontSize: 18)),
                  onPressed: _calculateBMI,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ResultScreen extends StatefulWidget {
  final double bmi;

  const ResultScreen({super.key, required this.bmi});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Color?> _colorAnimation;

  String get bmiCategory {
    final bmi = widget.bmi;
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  Color get bmiColor {
    final bmi = widget.bmi;
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 25) return Colors.green;
    if (bmi < 30) return Colors.orange;
    return Colors.red;
  }

  String get healthAdvice {
    switch (bmiCategory) {
      case 'Underweight':
        return 'Consider eating more nutritious food and consulting a healthcare professional.';
      case 'Normal':
        return 'Great job! Maintain your healthy lifestyle.';
      case 'Overweight':
        return 'Try to exercise regularly and watch your diet.';
      case 'Obese':
        return 'Please consult a healthcare provider for personalized advice.';
      default:
        return '';
    }
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn);

    _colorAnimation = ColorTween(
      begin: Colors.white,
      end: bmiColor,
    ).animate(_animationController);

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bmiStr = widget.bmi.toStringAsFixed(1);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: _colorAnimation.value,
            title: const Text('BMI Result'),
            iconTheme: IconThemeData(
              color: _colorAnimation.value!.computeLuminance() > 0.5
                  ? Colors.black
                  : Colors.white,
            ),
            titleTextStyle: TextStyle(
              color: _colorAnimation.value!.computeLuminance() > 0.5
                  ? Colors.black
                  : Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          body: Container(
            color: _colorAnimation.value,
            padding: const EdgeInsets.all(24),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Your BMI is',
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    bmiStr,
                    style: const TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    bmiCategory,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    healthAdvice,
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 14),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
