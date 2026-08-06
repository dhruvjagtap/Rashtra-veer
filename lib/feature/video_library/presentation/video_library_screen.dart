import 'package:flutter/material.dart';

import 'package:rashtraveer/feature/daily_task/data/models/task_subtask_model.dart';
import 'package:rashtraveer/feature/daily_task/data/repositories/task_subtask_repository.dart';

import 'package:rashtraveer/feature/video_library/widgets/header.dart';
import 'package:rashtraveer/feature/video_library/widgets/program_day_card.dart';
import 'package:rashtraveer/feature/video_library/presentation/video_player_screen.dart';

class VideoLibraryScreen extends StatefulWidget {
  static const routeName = '/video-library';

  final String taskId;
  // final TaskSubtaskModel subtask;

  const VideoLibraryScreen({
    super.key,
    required this.taskId,
    // required this.subtask,
  });

  @override
  State<VideoLibraryScreen> createState() => _VideoLibraryScreenState();
}

class _VideoLibraryScreenState extends State<VideoLibraryScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TaskSubtaskModel>>(
      stream: TaskSubtaskRepository().streamSubTasks(widget.taskId),

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text(snapshot.error.toString())));
        }

        final subtasks = snapshot.data ?? [];

        return Scaffold(
          backgroundColor: const Color(0xFFFAFAF8),

          body: Column(
            children: [
              CustomHeader(
                completedDays: subtasks
                    .where((e) => e.status == "Completed")
                    .length,

                totalDays: subtasks.length,

                streak: 3,
              ),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),

                  itemCount: subtasks.length,

                  itemBuilder: (context, index) {
                    final subtask = subtasks[index];

                    return ProgramDayCard(
                      subtask: subtask,

                      isUnlocked: subtask.status != "Locked",

                      onTap: () async {
                        if (subtask.status == "Locked") {
                          return;
                        }

                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VideoPlayerScreen(
                              taskId: widget.taskId,
                              subtask: subtask,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
