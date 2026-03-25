import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rashtraveer/feature/auth/presentation/login_screen.dart';
import 'package:rashtraveer/feature/auth/presentation/register_screen.dart';
import 'package:rashtraveer/feature/auth/presentation/verify_otp_scree.dart';
import 'package:rashtraveer/feature/main_application/home/presentation/home_screen.dart';
import 'package:rashtraveer/feature/main_application/leaderboard/presentation/leaderboard_screen.dart';
import 'package:rashtraveer/feature/main_application/chat/presentation/chat_home_screen.dart';
import 'package:rashtraveer/feature/onboarding/presentation/on_boarding_screen.dart';
import 'firebase_options.dart';

// import 'package:rashtraveer/feature/auth/presentation/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ChatHomeScreen(),
    );
  }
}

// keytool -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore
