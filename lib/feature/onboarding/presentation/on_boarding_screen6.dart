import 'package:flutter/material.dart';

import 'package:rashtraveer/feature/main_application/main_app_screen.dart';
import 'package:rashtraveer/feature/onboarding/widgets/top_section.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingScreen6 extends StatefulWidget {
  static const routeName = '/onBoardingScreen6';

  const OnBoardingScreen6({super.key});

  @override
  State<OnBoardingScreen6> createState() => _OnBoardingScreen6State();
}

class _OnBoardingScreen6State extends State<OnBoardingScreen6> {
  int selectedPlanIndex = 1;

  final plans = [
    {"price": 100, "title": "Basic", "desc": "Starter plan"},
    {"price": 200, "title": "Popular", "desc": "Most chosen"},
    {"price": 400, "title": "Premium", "desc": "Full access"},
  ];

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: selectedPlanIndex,
      viewportFraction: 0.7,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isLoggedIn', true);
    await prefs.setBool('isProfileComplete', true);

    // ignore: use_build_context_synchronously
    Navigator.pushReplacementNamed(context, MainAppScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF8),
      body: SafeArea(
        child: Column(
          children: [
            const TopSection(),

            const SizedBox(height: 20),

            const Text(
              "Your Plan is Ready",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              "Unlock your personalized fitness journey",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            _buildBenefits(),

            const SizedBox(height: 30),

            SizedBox(
              height: 240,
              child: PageView.builder(
                controller: _pageController,
                itemCount: plans.length,
                onPageChanged: (index) {
                  setState(() {
                    selectedPlanIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final plan = plans[index];
                  final isSelected = selectedPlanIndex == index;

                  return AnimatedScale(
                    duration: const Duration(milliseconds: 300),
                    scale: isSelected ? 1.0 : 0.9,
                    child: GestureDetector(
                      onTap: () {
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Transform.rotate(
                        angle: isSelected ? 0 : -0.03,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 10,
                          ),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.green : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.green
                                  : Colors.grey.shade300,
                              width: 1.5,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: Colors.green.shade100,
                                      blurRadius: 12,
                                    ),
                                  ]
                                : [],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                plan["title"].toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "₹${plan["price"]}",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                "/month",
                                style: TextStyle(fontSize: 12),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                plan["desc"].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white70
                                      : Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 12),
                              if (index == 1)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    "BEST",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _finishOnboarding,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Color(0xFF4C4A99),
                      ),
                      child: Text(
                        "Continue with ₹${plans[selectedPlanIndex]["price"]}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefits() {
    final benefits = [
      "Personalized workout plan",
      "Diet & nutrition guidance",
      "Progress tracking",
      "Expert support",
    ];

    return Column(
      children: benefits.map((b) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 18),
              const SizedBox(width: 8),
              Text(b),
            ],
          ),
        );
      }).toList(),
    );
  }
}
