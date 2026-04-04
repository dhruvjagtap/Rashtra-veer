import 'package:flutter/material.dart';
import 'package:rashtraveer/feature/onboarding/presentation/on_boarding_screen5.dart';
import 'package:rashtraveer/feature/onboarding/widgets/top_section.dart';

enum StepState { activity, lifestyle, time, done }

class OnBoardingScreen4 extends StatefulWidget {
  static const routeName = '/onBoardingScreen4';

  const OnBoardingScreen4({super.key});

  @override
  State<OnBoardingScreen4> createState() => _OnBoardingScreen4State();
}

class _OnBoardingScreen4State extends State<OnBoardingScreen4> {
  String selectedActivity = "";
  String selectedLifestyle = "";
  int selectedTime = 0;

  StepState currentStep = StepState.activity;

  final activityLevels = [
    {
      "title": "Beginner",
      "subtitle": "No regular exercise",
      "icon": Icons.self_improvement,
    },
    {
      "title": "Intermediate",
      "subtitle": "2-3 days/week",
      "icon": Icons.fitness_center,
    },
    {"title": "Advanced", "subtitle": "Daily workouts", "icon": Icons.flash_on},
  ];

  final lifestyles = [
    {"title": "Sedentary", "subtitle": "Desk job", "icon": Icons.chair_alt},
    {
      "title": "Moderate",
      "subtitle": "Some movement",
      "icon": Icons.directions_walk,
    },
    {
      "title": "Active",
      "subtitle": "Physical work",
      "icon": Icons.local_fire_department,
    },
  ];

  final timeOptions = [15, 30, 45, 60];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF8),
      body: SafeArea(
        child: Column(
          children: [
            const TopSection(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: _progressValue()),
                duration: const Duration(milliseconds: 400),
                builder: (context, value, _) {
                  return LinearProgressIndicator(
                    value: value,
                    backgroundColor: Colors.grey.shade200,
                    color: Colors.green,
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              "Tell us about your routine",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 6),

            const Text(
              "This helps us personalize your plan",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, animation) {
                  final offsetAnimation = Tween<Offset>(
                    begin: const Offset(0.2, 0),
                    end: Offset.zero,
                  ).animate(animation);

                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    ),
                  );
                },
                child: _buildStepContent(),
              ),
            ),

            _buildBottomButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (currentStep) {
      case StepState.activity:
        return _buildStep(
          key: const ValueKey("activity"),
          title: "Activity Level",
          child: _buildCards(activityLevels, selectedActivity, (value) {
            setState(() {
              selectedActivity = value;
              currentStep = StepState.lifestyle;
            });
          }),
        );

      case StepState.lifestyle:
        return _buildStep(
          key: const ValueKey("lifestyle"),
          title: "Lifestyle",
          child: _buildCards(lifestyles, selectedLifestyle, (value) {
            setState(() {
              selectedLifestyle = value;
              currentStep = StepState.time;
            });
          }),
        );

      case StepState.time:
        return _buildStep(
          key: const ValueKey("time"),
          title: "Daily Time Available",
          child: _buildTimeChips(),
        );

      default:
        return const SizedBox();
    }
  }

  Widget _buildStep({
    required Widget child,
    required String title,
    required Key key,
  }) {
    return SingleChildScrollView(
      key: key,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildCards(
    List<Map<String, dynamic>> items,
    String selectedValue,
    Function(String) onTap,
  ) {
    return Column(
      children: items.map((item) {
        final isSelected = selectedValue == item["title"];

        return GestureDetector(
          onTap: () => onTap(item["title"]),
          child: AnimatedScale(
            scale: isSelected ? 1.03 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected ? Colors.green.shade50 : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? Colors.green : Colors.grey.shade200,
                  width: 1.5,
                ),
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: Colors.green.withValues(alpha: 0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    item["icon"],
                    color: isSelected ? Colors.green : Colors.grey,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item["title"],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item["subtitle"],
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTimeChips() {
    return Wrap(
      spacing: 10,
      children: timeOptions.map((time) {
        final isSelected = selectedTime == time;

        return ChoiceChip(
          label: Text("$time min"),
          selected: isSelected,
          selectedColor: Colors.green,
          backgroundColor: Colors.grey.shade100,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onSelected: (_) {
            setState(() {
              selectedTime = time;
              currentStep = StepState.done;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildBottomButton() {
    final isVisible = currentStep == StepState.done;

    return AnimatedSlide(
      offset: isVisible ? Offset.zero : const Offset(0, 1),
      duration: const Duration(milliseconds: 300),
      child: AnimatedOpacity(
        opacity: isVisible ? 1 : 0,
        duration: const Duration(milliseconds: 300),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _handleNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                "Continue",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _progressValue() {
    switch (currentStep) {
      case StepState.activity:
        return 0.25;
      case StepState.lifestyle:
        return 0.5;
      case StepState.time:
        return 0.75;
      case StepState.done:
        return 1;
    }
  }

  void _handleNext() {
    /// Navigate next
    Navigator.pushNamed(context, OnBoardingScreen5.routeName);
  }
}
