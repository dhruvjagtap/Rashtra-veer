import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

import 'package:rashtraveer/feature/daily_task/data/models/task_subtask_model.dart';
import 'package:rashtraveer/feature/daily_task/data/repositories/task_subtask_repository.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String taskId;
  final TaskSubtaskModel subtask;

  const VideoPlayerScreen({
    super.key,
    required this.taskId,
    required this.subtask,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    debugPrint("Task ID: ${widget.taskId}");
    debugPrint("Subtask ID: ${widget.subtask.id}");
    debugPrint("Video URL: ${widget.subtask.videoId}");

    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.subtask.videoId),
    );

    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      await _videoPlayerController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: false,
      );

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint("Video Error: $e");
    }
  }

  Future<void> _markCompleted() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await TaskSubtaskRepository().markSubTaskCompleted(
        taskId: widget.taskId,
        subtaskId: widget.subtask.id,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Subtask Completed 🎉")));

      Navigator.pop(context);
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool completed = widget.subtask.status.toLowerCase() == "completed";

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            /// HEADER
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  Expanded(
                    child: Text(
                      widget.subtask.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// VIDEO PLAYER
            Expanded(
              child: Center(
                child: _chewieController == null
                    ? const CircularProgressIndicator()
                    : Chewie(controller: _chewieController!),
              ),
            ),

            /// DESCRIPTION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Text(
                widget.subtask.description,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),

            /// COMPLETE BUTTON
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: completed || _isLoading ? null : _markCompleted,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A66FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          completed ? "Completed" : "Mark as Completed",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
