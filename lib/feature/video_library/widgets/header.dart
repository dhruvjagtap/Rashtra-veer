import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  final int completedDays;
  final int totalDays;
  final int streak;

  const CustomHeader({
    super.key,
    required this.completedDays,
    required this.totalDays,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    final progress = completedDays / totalDays;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        // gradient: LinearGradient(
        //   colors: [Color(0xFF7F7BFF), Color(0xFF6A66FF)],
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        // ),
        color: Color(0xFF6A66FF),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 120, // stable across devices
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// 🔹 Top Row
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Today's Program",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// 🔹 Streak + Progress
              Row(
                children: [
                  const Icon(Icons.local_fire_department, color: Colors.orange),
                  const SizedBox(width: 6),
                  Text(
                    "$streak Day Streak",
                    style: const TextStyle(color: Colors.white),
                  ),
                  const Spacer(),
                  Text(
                    "$completedDays / $totalDays Completed",
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              /// 🔹 Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: Colors.white.withValues(alpha: 0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
