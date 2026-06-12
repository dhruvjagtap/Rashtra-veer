// lib/core/splash_screen.dart
import 'package:flutter/material.dart';
import '../feature/auth/presentation/login_screen.dart';
import '../feature/main_application/main_app_screen.dart';
import '../feature/onboarding/presentation/on_boarding_screen1.dart';
import '../feature/auth/model/user_model.dart';
import '../providers/user_provider.dart';
import '../providers/repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rashtraveer/feature/onboarding/presentation/payment_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends ConsumerStatefulWidget {
  static const routeName = '/splash';

  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkUser();
    });
  }

  Future<void> _checkUser() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    User? firebaseUser = FirebaseAuth.instance.currentUser;

    // User not logged in
    if (firebaseUser == null) {
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      return;
    }

    // Refresh auth state
    try {
      await firebaseUser.reload();
    } catch (_) {}

    firebaseUser = FirebaseAuth.instance.currentUser;

    // User deleted from Firebase Authentication
    if (firebaseUser == null) {
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      return;
    }

    final repo = ref.read(userRepositoryProvider);

    UserModel? user;

    try {
      user = await repo.getUser(firebaseUser.uid);
    } catch (e) {
      debugPrint('Error loading user: $e');

      await FirebaseAuth.instance.signOut();

      if (!mounted) return;

      Navigator.pushReplacementNamed(context, LoginScreen.routeName);

      return;
    }

    // Firestore document missing
    if (user == null) {
      await FirebaseAuth.instance.signOut();

      ref.read(userProvider.notifier).clearUser();

      if (!mounted) return;

      Navigator.pushReplacementNamed(context, LoginScreen.routeName);

      return;
    }

    // Save user globally
    ref.read(userProvider.notifier).setUser(user);

    if (!mounted) return;

    // Onboarding pending
    if (!(user.onboardingCompleted ?? false)) {
      Navigator.pushReplacementNamed(context, OnBoardingScreen1.routeName);
      return;
    }

    // Payment pending
    if (!(user.paymentCompleted ?? false)) {
      Navigator.pushReplacementNamed(
        context,
        PaymentScreen.routeName,
        arguments: {'planTitle': 'Popular', 'planPrice': 200},
      );
      return;
    }

    // Everything completed
    Navigator.pushReplacementNamed(context, MainAppScreen.routeName);
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
