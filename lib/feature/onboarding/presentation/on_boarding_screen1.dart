import 'package:flutter/material.dart';
import 'package:rashtraveer/feature/onboarding/presentation/on_boarding_screen2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rashtraveer/providers/onboarding_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum BMIState { input, loading, result }

class OnBoardingScreen1 extends ConsumerStatefulWidget {
  static const routeName = '/onBoardingScreen1';
  const OnBoardingScreen1({super.key});

  @override
  ConsumerState<OnBoardingScreen1> createState() => _OnBoardingScreen1State();
}

class _OnBoardingScreen1State extends ConsumerState<OnBoardingScreen1> {
  final TextEditingController heightController = TextEditingController(
    text: "170",
  );

  final TextEditingController weightController = TextEditingController(
    text: "65",
  );

  late TextEditingController ageController;

  int age = 22;
  String gender = "Male";
  double bmi = 0;

  @override
  void initState() {
    super.initState();
    ageController = TextEditingController(text: age.toString());
  }

  @override
  void dispose() {
    heightController.dispose();
    weightController.dispose();
    ageController.dispose();
    super.dispose();
  }

  Color getPrimaryColor() {
    if (gender == "Male") {
      return Color(0xFF2664F5);
    } else if (gender == "Female") {
      return Colors.pink;
    }
    return Colors.green;
  }

  Future<void> _saveStep1ToProvider() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final height = double.tryParse(heightController.text) ?? 0;
    final weight = double.tryParse(weightController.text) ?? 0;
    final ageValue = int.tryParse(ageController.text) ?? 0;

    final bmiValue = weight / ((height / 100) * (height / 100));

    debugPrint('Height: $height');
    debugPrint('Weight: $weight');
    debugPrint('Age: $ageValue');
    debugPrint('BMI: $bmiValue');

    ref
        .read(onboardingProvider.notifier)
        .updateBasicInfo(
          uid: user.uid,
          height: height,
          weight: weight,
          gender: gender,
          age: ageValue,
          bmi: bmiValue,
        );

    ref.read(onboardingProvider.notifier).updateStep(1);

    final prefs = await SharedPreferences.getInstance();
    debugPrint('Shared Preferences: ');
    prefs.getKeys().forEach((k) => debugPrint('$k: ${prefs.get(k)}'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF8),
      body: SafeArea(
        child: Column(
          children: [
            // CENTER CONTENT
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildInput(),
                ),
              ),
            ),

            // BOTTOM BUTTON
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  // Replace your Next button onPressed with this
                  onPressed: () async {
                    try {
                      await _saveStep1ToProvider();

                      if (!mounted) return;

                      Navigator.pushNamed(context, OnBoardingScreen2.routeName);
                    } catch (e) {
                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to save data: $e')),
                      );
                    }
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text("Next"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput() {
    return Column(
      children: [
        const SizedBox(height: 10),

        const Text(
          "BMI Calculator",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4C4A99),
          ),
        ),

        const SizedBox(height: 24),

        Row(
          children: [
            Expanded(child: _buildGenderCard("Male")),
            const SizedBox(width: 12),
            Expanded(child: _buildGenderCard("Female")),
          ],
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: _buildNumberInput(
                title: "Height (cm)",
                // unit: "cm",
                controller: heightController,
                onIncrement: () => _updateValue(heightController, 1),
                onDecrement: () => _updateValue(heightController, -1),
                compact: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildNumberInput(
                title: "Weight (kg)",
                // unit: "kg",
                controller: weightController,
                onIncrement: () => _updateValue(weightController, 1),
                onDecrement: () => _updateValue(weightController, -1),
                compact: true,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        _buildNumberInput(
          title: "Age (years)",
          // unit: "",
          controller: ageController,
          compact: false,
          onIncrement: () {
            setState(() {
              age++;
              ageController.text = age.toString();
            });
          },
          onDecrement: () {
            if (age > 0) {
              setState(() {
                age--;
                ageController.text = age.toString();
              });
            }
          },
        ),

        const SizedBox(height: 32),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              // backgroundColor: const Color(0xFF4C4A99),
              backgroundColor: getPrimaryColor(),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: _calculateBMI,
            child: const Text(
              "Calculate BMI",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildGenderCard(String type) {
    final isSelected = gender == type;

    return GestureDetector(
      onTap: () => setState(() => gender = type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isSelected ? getPrimaryColor() : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              type == "Male" ? Icons.male : Icons.female,
              color: isSelected ? Colors.white : Colors.grey,
              size: 40,
            ),
            const SizedBox(height: 8),
            Text(
              type,
              style: TextStyle(color: isSelected ? Colors.white : Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberInput({
    required String title,
    // required String unit,
    required TextEditingController controller,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
    bool compact = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(title),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton(
                iconSize: compact ? 18 : 24,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.remove),
                onPressed: onDecrement,
              ),

              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    // suffixText: unit,
                    border: InputBorder.none,
                  ),
                ),
              ),

              IconButton(
                iconSize: compact ? 18 : 24,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.add),
                onPressed: onIncrement,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _updateValue(TextEditingController controller, int delta) {
    double val = double.tryParse(controller.text) ?? 0;
    val += delta;
    if (val >= 0) {
      controller.text = val.toString();
    }
  }

  void _calculateBMI() {
    double h = double.tryParse(heightController.text) ?? 0;
    double w = double.tryParse(weightController.text) ?? 0;

    if (h <= 0 || w <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid height & weight")),
      );
      return;
    }

    double bmiValue = w / ((h / 100) * (h / 100));

    String category;
    Color resultColor;

    if (bmiValue < 18.5) {
      category = "Underweight";
      resultColor = Colors.orange;
    } else if (bmiValue < 25) {
      category = "Normal";
      resultColor = Colors.green;
    } else if (bmiValue < 30) {
      category = "Overweight";
      resultColor = Colors.deepOrange;
    } else {
      category = "Obese";
      resultColor = Colors.red;
    }
    // How to set width for ModalBottomSheet ?
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // important for full width feel
      builder: (_) => FractionallySizedBox(
        widthFactor: 1, // FULL WIDTH
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // your content
                  const Text(
                    "Your BMI Result",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    bmiValue.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: resultColor,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    category,
                    style: TextStyle(fontSize: 20, color: resultColor),
                  ),

                  const SizedBox(height: 20),

                  const Text('Suggested weight'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
