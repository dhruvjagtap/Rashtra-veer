import 'package:flutter/material.dart';

class BadgesScreen extends StatelessWidget {
  const BadgesScreen({super.key});

  static const routeName = '/badges';
  static const List<_Badge> _earned = [
    _Badge(
      icon: Icons.local_fire_department_rounded,
      label: 'First Flame',
      description: 'Completed your first workout',
      color: Colors.deepOrange,
      earnedOn: 'Apr 1, 2026',
    ),
    _Badge(
      icon: Icons.bolt_rounded,
      label: '7-Day Streak',
      description: 'Worked out 7 days in a row',
      color: Color(0xFF7F7BFF),
      earnedOn: 'Apr 5, 2026',
    ),
    _Badge(
      icon: Icons.emoji_events_rounded,
      label: 'Top 50',
      description: 'Ranked in the top 50 on leaderboard',
      color: Colors.amber,
      earnedOn: 'Apr 6, 2026',
    ),
    _Badge(
      icon: Icons.favorite_rounded,
      label: 'Health Hero',
      description: 'Logged meals for 5 consecutive days',
      color: Colors.pinkAccent,
      earnedOn: 'Apr 3, 2026',
    ),
  ];

  static const List<_Badge> _locked = [
    _Badge(
      icon: Icons.military_tech_rounded,
      label: '30-Day Warrior',
      description: 'Complete a 30-day streak',
      color: Colors.grey,
    ),
    _Badge(
      icon: Icons.directions_run_rounded,
      label: 'Marathon Ready',
      description: 'Log 42km of total running distance',
      color: Colors.grey,
    ),
    _Badge(
      icon: Icons.group_rounded,
      label: 'Community Star',
      description: 'Join or create 3 groups',
      color: Colors.grey,
    ),
    _Badge(
      icon: Icons.star_rounded,
      label: 'Top 10',
      description: 'Reach the top 10 on the leaderboard',
      color: Colors.grey,
    ),
    _Badge(
      icon: Icons.self_improvement_rounded,
      label: 'Zen Master',
      description: 'Complete 10 meditation sessions',
      color: Colors.grey,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAF8),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF21212E)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Badges & Achievements',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF21212E),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7F7BFF), Color(0xFF5A54E8)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.workspace_premium_rounded,
                      color: Colors.amber, size: 40),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '4 Badges Earned',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '5 more to unlock',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            _sectionLabel('Earned'),
            const SizedBox(height: 12),
            ..._earned.map((b) => _BadgeTile(badge: b, isLocked: false)),

            const SizedBox(height: 24),

            _sectionLabel('Locked'),
            const SizedBox(height: 12),
            ..._locked.map((b) => _BadgeTile(badge: b, isLocked: true)),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF21212E),
      ),
    );
  }
}

class _BadgeTile extends StatelessWidget {
  const _BadgeTile({required this.badge, required this.isLocked});

  final _Badge badge;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isLocked
                  ? Colors.grey.shade100
                  : badge.color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isLocked ? Icons.lock_outline_rounded : badge.icon,
              color: isLocked ? Colors.grey.shade400 : badge.color,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  badge.label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isLocked ? Colors.grey.shade500 : Colors.black87,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  badge.description,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          if (!isLocked && badge.earnedOn != null)
            Text(
              badge.earnedOn!,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
        ],
      ),
    );
  }
}

class _Badge {
  const _Badge({
    required this.icon,
    required this.label,
    required this.description,
    required this.color,
    this.earnedOn,
  });

  final IconData icon;
  final String label;
  final String description;
  final Color color;
  final String? earnedOn;
}