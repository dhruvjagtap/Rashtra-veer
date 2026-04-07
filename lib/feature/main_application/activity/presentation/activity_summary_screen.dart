import 'package:flutter/material.dart';

class ActivitySummaryScreen extends StatelessWidget {
  const ActivitySummaryScreen({super.key});

  static const Color primaryColor = Color(0xFF7F7BFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SummaryHeader(),
            const SizedBox(height: 16),
            const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: StatsCardsSection(),
            ),
            const SizedBox(height: 16),
            const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: WorkoutChartCard(),
            ),
            const SizedBox(height: 20),
            const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ShareButton(),
            ),
          ],
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////
/// HEADER
//////////////////////////////////////////////////////////////
class SummaryHeader extends StatelessWidget {
  const SummaryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 16,
        bottom: 24,
      ), 
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF7F7BFF), Color(0xFF5A54E8)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          /// INNER PADDING ONLY FOR CONTENT
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      "Activity Summary",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 24),
              ],
            ),
          ),

          const SizedBox(height: 6),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            // child: Text(
            //   "Rashtraveer Fitness Challenge",
            //   style: TextStyle(color: Colors.white70, fontSize: 13),
            // ),
          ),
        ],
      ),
    );
  }
}

//////////////////////////////////////////////////////////////
/// STATS CARDS
//////////////////////////////////////////////////////////////
class StatsCardsSection extends StatelessWidget {
  const StatsCardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        StatCard(
          icon: Icons.directions_run,
          value: "5.2",
          unit: "km",
          label: "Distance",
          color: Color(0xFF4CAF50), // green
        ),
        StatCard(
          icon: Icons.timer,
          value: "45:30",
          unit: "min",
          label: "Duration",
          color: Color(0xFF00BCD4), // teal
        ),
        StatCard(
          icon: Icons.local_fire_department,
          value: "320",
          unit: "kcal",
          label: "Calories",
          color: Color(0xFFFF7043), // orange
        ),
      ],
    );
  }
}


class StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String unit;
  final String label;
  final Color color;

  const StatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.unit,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.white),
                children: [
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: " $unit"),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


//////////////////////////////////////////////////////////////
/// CHART
/////////////////////////////////////////////////////////////

class WorkoutChartCard extends StatelessWidget {
  const WorkoutChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Workout Intensity",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),

          /// FIXED GRAPH
          SizedBox(
            height: 150,
            width: double.infinity,
            child: CustomPaint(
              painter: GraphPainter(),
              child: Container(), // important fix
            ),
          ),
        ],
      ),
    );
  }
}

class GraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    ///  GRID LINES (background)
    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1;

    for (int i = 1; i <= 4; i++) {
      final y = size.height * i / 5;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    /// 🔥 MAIN GRAPH LINE
    final paint = Paint()
      ..color = ActivitySummaryScreen.primaryColor
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(
      size.width * 0.2,
      size.height * 0.2,
      size.width * 0.4,
      size.height * 0.5,
    );
    path.quadraticBezierTo(
      size.width * 0.6,
      size.height * 0.1,
      size.width * 0.7,
      size.height * 0.6,
    );
    path.quadraticBezierTo(
      size.width * 0.9,
      size.height * 0.3,
      size.width,
      size.height * 0.7,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

//////////////////////////////////////////////////////////////
/// SHARE BUTTON
//////////////////////////////////////////////////////////////

class ShareButton extends StatelessWidget {
  const ShareButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Shared successfully!!")),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF7F7BFF), Color(0xFF5A54E8)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.share, color: Colors.white),
              SizedBox(width: 8),
              Text(
                "Share Achievement",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}