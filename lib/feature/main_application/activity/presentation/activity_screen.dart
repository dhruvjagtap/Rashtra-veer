import 'package:flutter/material.dart';
import 'activity_summary_screen.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  static const Color primaryColor = Color(0xFF7F7BFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            HeaderSection(),
            SizedBox(height: 16),
            ProgressSection(),
            SizedBox(height: 16),
            StatsSection(),
            SizedBox(height: 16),
            ActionPlanSection(),
            SizedBox(height: 16),
            WeeklyConsistencySection(),
            SizedBox(height: 16),
            RewardCard(),
          ],
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////
/// HEADER
//////////////////////////////////////////////////////////////
class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// TOP BAR (Minimal Header)
        Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).maybePop(),
              child: const Icon(Icons.arrow_back),
            ),
            const Expanded(
              child: Center(
                child: Text(
                  "Activity",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 24), // balance for center alignment
          ],
        ),

        const SizedBox(height: 20),

        /// GREETING TEXT (no card, clean like image)
        const SizedBox(height: 4),
        const Text(
          "Let’s crush today’s goals.",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ],
    );
  }
}

//////////////////////////////////////////////////////////////
/// PROGRESS CIRCLE
/////////////////////////////////////////////////////////////

class ProgressSection extends StatelessWidget {
  const ProgressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// ANIMATED PROGRESS CIRCLE
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 0.65),
          duration: const Duration(seconds: 1),
          builder: (context, value, _) {
            return Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 180,
                  width: 180,
                  child: CircularProgressIndicator(
                    value: value,
                    strokeWidth: 12,
                    strokeCap: StrokeCap.round,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation(
                      ActivityScreen.primaryColor,
                    ),
                  ),
                ),

                /// CENTER TEXT
                const Column(
                  children: [
                    Text(
                      "65%",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "COMPLETE",
                      style: TextStyle(
                        fontSize: 12,
                        letterSpacing: 1.2,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 20),

        /// CLICKABLE BUTTON
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ActivitySummaryScreen(),
              ),
            );
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: ActivityScreen.primaryColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: Text(
                "View Full Summary",
                style: TextStyle(
                  color: ActivityScreen.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
//////////////////////////////////////////////////////////////
/// STATS (STREAK / TASKS / POINTS)
//////////////////////////////////////////////////////////////

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          StatItem(title: "Streak", value: "5 Days"),
          StatItem(title: "Tasks", value: "3/5"),
          StatItem(title: "Points", value: "120 Pts"),
        ],
      ),
    );
  }
}

class StatItem extends StatelessWidget {
  final String title;
  final String value;

  const StatItem({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.local_fire_department,
            color: ActivityScreen.primaryColor),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

//////////////////////////////////////////////////////////////
/// ACTION PLAN
//////////////////////////////////////////////////////////////

class ActionPlanSection extends StatelessWidget {
  const ActionPlanSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Today's Action Plan",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),

        ActionCard(
          title: "Strength Training",
          subtitle: "45 mins • Intermediate",
          icon: Icons.fitness_center,
          isCompleted: false,
        ),
        ActionCard(
          title: "Keto Meal Plan",
          subtitle: "Breakfast & Lunch",
          icon: Icons.restaurant,
          isCompleted: true,
        ),
        ActionCard(
          title: "Mindful Meditation",
          subtitle: "10 mins • Relaxing",
          icon: Icons.self_improvement,
          isCompleted: false,
        ),
      ],
    );
  }
}

class ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isCompleted;

  const ActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: ActivityScreen.primaryColor.withOpacity(0.1),
            child: Icon(icon, color: ActivityScreen.primaryColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(subtitle,
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          isCompleted
              ? const Icon(Icons.check_circle, color: Colors.green)
              : const Icon(Icons.radio_button_unchecked, color: Colors.grey),
        ],
      ),
    );
  }
}

//////////////////////////////////////////////////////////////
/// WEEKLY CONSISTENCY
//////////////////////////////////////////////////////////////

class WeeklyConsistencySection extends StatelessWidget {
  const WeeklyConsistencySection({super.key});

  @override
  Widget build(BuildContext context) {
    final days = ["S", "M", "T", "W", "T", "F", "S"];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Weekly Consistency",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(days.length, (index) {
              final isActive = index < 3;
              return Column(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: isActive
                        ? ActivityScreen.primaryColor
                        : Colors.grey.shade300,
                    child: isActive
                        ? const Icon(Icons.check,
                            size: 16, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(height: 6),
                  Text(days[index],
                      style: const TextStyle(fontSize: 12)),
                ],
              );
            }),
          )
        ],
      ),
    );
  }
}

//////////////////////////////////////////////////////////////
/// REWARD CARD
//////////////////////////////////////////////////////////////

class RewardCard extends StatelessWidget {
  const RewardCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7F7BFF), Color(0xFF5A54E8)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          Icon(Icons.emoji_events, color: Colors.white),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Early Bird Unlock!",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Current Rank: 42nd",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16)
        ],
      ),
    );
  }
}