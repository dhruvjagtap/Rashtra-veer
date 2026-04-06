import 'package:flutter/material.dart';

import 'widgets/chat_list_item.dart';

class ChatHomeScreen extends StatelessWidget {
  const ChatHomeScreen({super.key});

  static const Color _screenBg = Color(0xFFFAFAF8);
  static const Color _surfaceMuted = Color(0xFFF3F3F6);

  static const List<_ChatPreview> _chats = [
    _ChatPreview(
      name: 'Coach Vikram Singh',
      message: 'Your macro ratios look perfect today.',
      timeLabel: '12:45 PM',
      unreadCount: 2,
    ),
    _ChatPreview(
      name: 'Dr. Ananya Iyer',
      message: 'The inflammation test results are in.',
      timeLabel: '10:20 AM',
    ),
    _ChatPreview(
      name: 'Rohan (Team Alpha)',
      message: 'Shared the morning run stats in the group.',
      timeLabel: 'Yesterday',
    ),
    _ChatPreview(
      name: 'Neha Wellness',
      message: 'Remember your mobility drills this evening.',
      timeLabel: 'Mon',
      unreadCount: 1,
    ),
    _ChatPreview(
      name: 'Weekend Warriors',
      message: 'Ready for Saturday hike? Confirm your slot.',
      timeLabel: 'Tue',
    ),
    _ChatPreview(
      name: 'Nutrition Desk',
      message: 'New meal template uploaded for this week.',
      timeLabel: 'Wed',
      unreadCount: 3,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: _screenBg,

      // ✅ CORRECT PLACE
      appBar: AppBar(
        backgroundColor: _screenBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Chats',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF21212E),
          ),
        ),
        centerTitle: false,
      ),

      // ❌ Removed SafeArea (AppBar handles it)
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: _surfaceMuted,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search experts...',
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.black45,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Colors.black38,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              itemCount: _chats.length,
              itemBuilder: (context, index) {
                final item = _chats[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ChatListItem(
                    name: item.name,
                    lastMessage: item.message,
                    timeLabel: item.timeLabel,
                    unreadCount: item.unreadCount,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(title: item.name),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatPreview {
  const _ChatPreview({
    required this.name,
    required this.message,
    required this.timeLabel,
    this.unreadCount = 0,
  });

  final String name;
  final String message;
  final String timeLabel;
  final int unreadCount;
}

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Center(
        child: Text(
          'Chat screen placeholder',
          style: theme.textTheme.bodyLarge,
        ),
      ),
    );
  }
}
