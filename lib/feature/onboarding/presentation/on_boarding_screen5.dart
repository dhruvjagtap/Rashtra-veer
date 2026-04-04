import 'package:flutter/material.dart';
import 'package:rashtraveer/feature/onboarding/presentation/on_boarding_screen6.dart';
import 'package:rashtraveer/feature/onboarding/widgets/top_section.dart';

class OnBoardingScreen5 extends StatefulWidget {
  static const routeName = '/onBoardingScreen5';

  const OnBoardingScreen5({super.key});

  @override
  State<OnBoardingScreen5> createState() => _OnBoardingScreen5State();
}

class _OnBoardingScreen5State extends State<OnBoardingScreen5> {
  String selectedWorkout = "";
  String selectedTime = "";

  final workouts = [
    {"title": "Home Workout", "icon": Icons.home},
    {"title": "Gym Workout", "icon": Icons.fitness_center},
    {"title": "Yoga", "icon": Icons.self_improvement},
    {"title": "Running", "icon": Icons.directions_run},
  ];

  final times = ["Morning", "Afternoon", "Evening", "Flexible"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF8),

      body: SafeArea(
        child: Column(
          children: [
            const TopSection(),

            const SizedBox(height: 10),

            const Text(
              "Almost Done",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            const Text(
              "Set your preferences to get your plan",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle("Preferred Workout"),

                    const SizedBox(height: 10),

                    _buildWorkoutGrid(),

                    const SizedBox(height: 25),

                    _sectionTitle("Best Time for You"),

                    const SizedBox(height: 10),

                    _buildTimeChips(),

                    const SizedBox(height: 30),

                    _buildMotivationCard(),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isValid() ? _handleFinish : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    "Start My Journey",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildWorkoutGrid() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: workouts.map((item) {
        final isSelected = selectedWorkout == item["title"];

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedWorkout = item["title"] as String;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: (MediaQuery.of(context).size.width - 52) / 2,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? Colors.green : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? Colors.green : Colors.grey.shade300,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.green.withValues(alpha: 0.02),
                        blurRadius: 10,
                      ),
                    ]
                  : [],
            ),
            child: Column(
              children: [
                Icon(
                  item["icon"] as IconData,
                  size: 30,
                  color: isSelected ? Colors.white : Colors.black,
                ),
                const SizedBox(height: 10),
                Text(
                  item["title"] as String,
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
      }).toList(),
    );
  }

  Widget _buildTimeChips() {
    return Wrap(
      spacing: 10,
      children: times.map((time) {
        final isSelected = selectedTime == time;

        return ChoiceChip(
          label: Text(time),
          selected: isSelected,
          selectedColor: Colors.green,
          backgroundColor: Colors.grey.shade100,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
          onSelected: (_) {
            setState(() {
              selectedTime = time;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildMotivationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          Icon(Icons.emoji_events, color: Colors.green),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "You're one step away from transforming your life",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  bool _isValid() {
    return selectedWorkout.isNotEmpty && selectedTime.isNotEmpty;
  }

  void _handleFinish() {
    Navigator.pushNamed(context, OnBoardingScreen6.routeName);
  }
}
