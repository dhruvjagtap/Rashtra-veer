import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rashtraveer/core/splash_screen.dart';
import 'package:rashtraveer/feature/auth/presentation/login_screen.dart';
import 'package:rashtraveer/feature/auth/presentation/register_screen.dart';
import 'package:rashtraveer/feature/auth/presentation/verify_otp_scree.dart';

import 'package:rashtraveer/feature/onboarding/presentation/on_boarding_screen1.dart';
import 'package:rashtraveer/feature/onboarding/presentation/on_boarding_screen2.dart';
import 'package:rashtraveer/feature/onboarding/presentation/on_boarding_screen3.dart';
import 'package:rashtraveer/feature/onboarding/presentation/on_boarding_screen4.dart';
import 'package:rashtraveer/feature/onboarding/presentation/on_boarding_screen5.dart';
import 'package:rashtraveer/feature/onboarding/presentation/on_boarding_screen6.dart';
// import 'package:rashtraveer/feature/main_application/chat/presentation/groups/group_members_screen.dart';

import 'package:rashtraveer/feature/main_application/main_app_screen.dart';

import 'package:rashtraveer/feature/main_application/main_app_screen.dart';

import 'package:rashtraveer/feature/main_application/main_app_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rashtraveer',
      debugShowCheckedModeBanner: false,

      // home: const GroupMembersScreen(),
      initialRoute: SplashScreen.routeName,

      routes: {
        SplashScreen.routeName: (context) => const SplashScreen(),

        LoginScreen.routeName: (context) => const LoginScreen(),
        RegisterScreen.routeName: (context) => const RegisterScreen(),
        VerifyOtpScreen.routeName: (context) => const VerifyOtpScreen(),

        OnBoardingScreen1.routeName: (context) => const OnBoardingScreen1(),
        OnBoardingScreen2.routeName: (context) => const OnBoardingScreen2(),
        OnBoardingScreen3.routeName: (context) => const OnBoardingScreen3(),
        OnBoardingScreen4.routeName: (context) => const OnBoardingScreen4(),
        OnBoardingScreen5.routeName: (context) => const OnBoardingScreen5(),
        OnBoardingScreen6.routeName: (context) => const OnBoardingScreen6(),

        MainAppScreen.routeName: (context) => const MainAppScreen(),
      },
    );
  }
}
