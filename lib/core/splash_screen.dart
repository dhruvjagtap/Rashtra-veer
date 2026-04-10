import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../feature/auth/presentation/login_screen.dart';
import '../feature/main_application/main_app_screen.dart';
import '../feature/onboarding/presentation/on_boarding_screen1.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkUser();
    });
  }

  void _checkUser() async {
    final prefs = await SharedPreferences.getInstance();

    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    bool isProfileComplete = prefs.getBool('isProfileComplete') ?? false;

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    debugPrint("isLoggedIn: $isLoggedIn");
    debugPrint("isProfileComplete: $isProfileComplete");

    if (!isLoggedIn) {
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    } else if (!isProfileComplete) {
      Navigator.pushReplacementNamed(context, OnBoardingScreen1.routeName);
    } else {
      Navigator.pushReplacementNamed(context, MainAppScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7F7BFF),
      body: const Center(
        child: Text(
          "Rashtraveer",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
