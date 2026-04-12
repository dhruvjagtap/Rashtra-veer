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

import "package:rashtraveer/feature/settings/presentation/settings_screen.dart";

import 'feature/gamification/presentation/badges_screen.dart';
import 'feature/onboarding/presentation/payment_screen.dart';
import 'feature/profile/presentation/edit_profile_screen.dart';
import 'firebase_options.dart';
import 'package:rashtraveer/feature/settings/presentation/certificate_screen.dart';
import 'package:rashtraveer/feature/settings/presentation/help_support_screen.dart';
import 'package:rashtraveer/feature/settings/presentation/profile_screen.dart';
import 'package:rashtraveer/feature/settings/presentation/activity_settings_screen.dart';
import 'package:rashtraveer/feature/settings/presentation/health_preferences_screen.dart';


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
        EditProfileScreen.routeName: (context) => const EditProfileScreen(),
        BadgesScreen.routeName: (context) => const BadgesScreen(),
        MainAppScreen.routeName: (context) => const MainAppScreen(),
        SettingsScreen.routeName: (context) => const SettingsScreen(),
        CertificateScreen.routeName: (context) => const CertificateScreen(),
        HelpSupportScreen.routeName: (context) => const HelpSupportScreen(),
        ProfileScreen.routeName: (context) => const ProfileScreen(),
        ActivitySettingsScreen.routeName: (context) => const ActivitySettingsScreen(),
        HealthPreferencesScreen.routeName: (context) => const HealthPreferencesScreen(),

        PaymentScreen.routeName: (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map;
          return PaymentScreen(
            planTitle: args['planTitle'],
            planPrice: args['planPrice'],
          );
        },
      },
    );
  }
}

