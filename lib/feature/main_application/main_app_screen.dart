import 'package:flutter/material.dart';

import 'package:rashtraveer/feature/main_application/chat/presentation/chat_home_screen.dart';
import 'package:rashtraveer/feature/main_application/home/presentation/home_screen.dart';
import 'package:rashtraveer/feature/main_application/leaderboard/presentation/leaderboard_screen.dart';

/// Shell with [BottomNavigationBar] and [IndexedStack] for main app tabs.
class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  static const routeName = '/home';

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  static const Color _primaryColor = Color(0xFF7F7BFF);

  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomeScreen(),
    ActivityScreen(),
    ResourcesScreen(),
    ChatHomeScreen(),
    LeaderboardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
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

/// Placeholder until the Activity feature is implemented.
class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF8),
      body: Center(
        child: Text('Activity', style: Theme.of(context).textTheme.titleLarge),
      ),
    );
  }
}

/// Placeholder until the Resources feature is implemented.
class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF8),
      body: Center(
        child: Text('Resources', style: Theme.of(context).textTheme.titleLarge),
      ),
    );
  }
}
