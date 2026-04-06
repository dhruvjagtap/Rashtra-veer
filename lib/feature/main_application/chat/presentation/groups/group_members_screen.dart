import 'package:flutter/material.dart';

class GroupMembersScreen extends StatelessWidget {
  static const routeName = '/groupMembers';

  const GroupMembersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const expandedHeight = 200.0;

    final members = [
      {"name": "Rohan Sharma", "isAdmin": true},
      {"name": "Neha Patil", "isAdmin": false},
      {"name": "Coach Vikram", "isAdmin": false},
      {"name": "Ananya Iyer", "isAdmin": false},
      {"name": "Neha Patil", "isAdmin": false},
      {"name": "Coach Vikram", "isAdmin": false},
      {"name": "Ananya Iyer", "isAdmin": false},
      {"name": "You", "isAdmin": false},
      {"name": "Rohan Sharma", "isAdmin": true},
      {"name": "Neha Patil", "isAdmin": false},
      {"name": "Coach Vikram", "isAdmin": false},
      {"name": "Ananya Iyer", "isAdmin": false},
      {"name": "Neha Patil", "isAdmin": false},
      {"name": "Coach Vikram", "isAdmin": false},
      {"name": "Ananya Iyer", "isAdmin": false},
      {"name": "You", "isAdmin": false},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF8),
      body: CustomScrollView(
        slivers: [
          /// ✅ SLIVER APP BAR (SMOOTH + NO BUGS)
          SliverAppBar(
            backgroundColor: const Color(0xFF6A66FF),
            expandedHeight: expandedHeight,
            pinned: true,
            leading: const BackButton(color: Colors.white),

            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final currentHeight = constraints.maxHeight;

                /// 👇 0 → collapsed, 1 → expanded
                final percent =
                    ((currentHeight - kToolbarHeight) /
                            (expandedHeight - kToolbarHeight))
                        .clamp(0.0, 1.0);

                return Stack(
                  alignment: Alignment.center,
                  children: [
                    /// 🔵 Background
                    Container(color: const Color(0xFF6A66FF)),

                    /// 🔺 EXPANDED CONTENT (no overflow now)
                    Opacity(
                      opacity: percent,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            SizedBox(height: 40),
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.group, size: 40),
                            ),
                            SizedBox(height: 12),
                            Text(
                              "Weekend Warriors",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "24 members",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ),

                    /// 🔻 COLLAPSED TITLE
                    Positioned(
                      left: 56,
                      bottom: 12,
                      child: Opacity(
                        opacity: 1 - percent,
                        child: const Row(
                          children: [
                            CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.group, size: 16),
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Weekend Warriors",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          /// 👥 MEMBERS LIST
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final member = members[index];

              return Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey.shade300,
                      child: const Icon(Icons.person, color: Colors.black54),
                    ),
                    title: Text(member["name"] as String),
                    subtitle: member["isAdmin"] as bool
                        ? const Text("Admin")
                        : null,
                  ),
                  const Divider(height: 0),
                ],
              );
            }, childCount: members.length),
          ),
        ],
      ),
    );
  }
}
