import 'package:flutter/material.dart';
import 'package:rashtraveer/feature/onboarding/presentation/on_boarding_screen4.dart';
import 'package:rashtraveer/feature/onboarding/widgets/top_section.dart';

class OnBoardingScreen3 extends StatefulWidget {
  static const routeName = '/onBoardingScreen3';
  const OnBoardingScreen3({super.key});
  @override
  State<OnBoardingScreen3> createState() => _OnBoardingScreen3State();
}

class _OnBoardingScreen3State extends State<OnBoardingScreen3> {
  String selectedGoal = "";

  final List<Map<String, dynamic>> goals = [
    {"title": "Lose Weight", "icon": Icons.local_fire_department},
    {"title": "Gain Muscle", "icon": Icons.fitness_center},
    {"title": "Stay Fit", "icon": Icons.balance},
    {"title": "Improve Stamina", "icon": Icons.directions_run},
    {"title": "Mental Wellness", "icon": Icons.self_improvement},
    {"title": "General Fitness", "icon": Icons.favorite},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF8),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const TopSection(),
              const Text(
                "What's your goal?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.builder(
                      itemCount: goals.length,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 1,
                          ),
                      itemBuilder: (_, index) {
                        final goal = goals[index];
                        return _buildGoalCard(goal);
                      },
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _handleNext,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text("Next"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoalCard(Map<String, dynamic> goal) {
    final isSelected = selectedGoal == goal["title"];

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGoal = goal["title"];
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey.shade300,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.green.withValues(alpha: 0.2),
                    blurRadius: 10,
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              goal["icon"],
              size: 40,
              color: isSelected ? Colors.white : Color(0xFF4C4A99),
            ),
            const SizedBox(height: 10),
            Text(
              goal["title"],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleNext() {
    // Navigate next
    Navigator.pushNamed(context, OnBoardingScreen4.routeName);
  }
}
