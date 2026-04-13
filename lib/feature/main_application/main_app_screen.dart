import 'package:flutter/material.dart';
import 'package:rashtraveer/feature/main_application/resources/presentation/resources_screen.dart';
import 'package:rashtraveer/feature/main_application/chat/presentation/chat_home_screen.dart';
import 'package:rashtraveer/feature/main_application/chat/data/chat_store.dart';
import 'package:rashtraveer/feature/main_application/home/presentation/home_screen.dart';
import 'package:rashtraveer/feature/main_application/leaderboard/presentation/leaderboard_screen.dart';
import 'package:rashtraveer/feature/main_application/activity/presentation/activity_screen.dart';

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  static const routeName = '/home';

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  static const Color _primaryColor = Color(0xFF7F7BFF);

  int _selectedIndex = 0;

  // ONE store for the lifetime of the app shell.
  // Passed directly to ChatHomeScreen — no InheritedWidget needed.
  final ChatStore _chatStore = ChatStore();

  @override
  void dispose() {
    _chatStore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const HomeScreen(),
          const ActivityScreen(),
          const ResourcesScreen(),
          // Store passed directly — clean, no import ambiguity
          ChatHomeScreen(store: _chatStore),
          const LeaderboardScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: _primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_run),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Resources',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Rank',
          ),
        ],
      ),
    );
  }
}