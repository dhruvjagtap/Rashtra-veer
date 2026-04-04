import 'package:flutter/material.dart';
import 'package:rashtraveer/feature/video_library/widgets/header.dart';
import 'package:rashtraveer/feature/video_library/widgets/program_day_card.dart';
import 'package:rashtraveer/feature/video_library/presentation/video_player_screen.dart';

class ProgramDay {
  final int dayNumber;
  final String title;
  final String duration;
  final String videoUrl;
  bool isCompleted;

  ProgramDay({
    required this.dayNumber,
    required this.title,
    required this.duration,
    required this.videoUrl,
    this.isCompleted = false,
  });
}

class VideoLibraryScreen extends StatefulWidget {
  static const routeName = '/video-library';
  const VideoLibraryScreen({super.key});

  @override
  State<VideoLibraryScreen> createState() => _VideoLibraryScreenState();
}

class _VideoLibraryScreenState extends State<VideoLibraryScreen> {
  List<ProgramDay> days = [
    ProgramDay(
      dayNumber: 1,
      title: "Full Body Warmup",
      duration: "10 min",
      videoUrl: "",
    ),
    ProgramDay(
      dayNumber: 2,
      title: "Fat Burn Workout",
      duration: "20 min",
      videoUrl: "",
    ),
    ProgramDay(
      dayNumber: 3,
      title: "Core Strength",
      duration: "15 min",
      videoUrl: "",
    ),
    ProgramDay(
      dayNumber: 4,
      title: "Yoga Recovery",
      duration: "12 min",
      videoUrl: "",
    ),
  ];

  bool isUnlocked(int index) {
    if (index == 0) return true;
    return days[index - 1].isCompleted;
  }

  void markCompleted(int index) {
    setState(() {
      days[index].isCompleted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF8),
      body: Column(
        children: [
          CustomHeader(
            completedDays: days.where((d) => d.isCompleted).length,
            totalDays: days.length,
            streak: 3, // Example streak value
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: days.length,
              itemBuilder: (context, index) {
                final day = days[index];
                return ProgramDayCard(
                  day: day,
                  isUnlocked: isUnlocked(index),
                  onTap: () {
                    // Navigate to video player screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPlayerScreen(day: day),
                      ),
                    ).then((_) {
                      // Mark as completed when returning from video player
                      markCompleted(index);
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
