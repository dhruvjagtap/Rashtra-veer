import 'package:flutter/material.dart';
import 'package:rashtraveer/feature/daily_task/data/constants/tasks_status.dart';
import 'package:rashtraveer/feature/daily_task/data/models/task_subtask_model.dart';

class ProgramDayCard extends StatelessWidget {
  final TaskSubtaskModel subtask;
  final VoidCallback onTap;
  final dynamic isUnlocked;

  const ProgramDayCard({
    super.key,
    required this.subtask,
    required this.isUnlocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = subtask.status == TaskStatus.completed;

    final bool isUnlocked = subtask.status != TaskStatus.locked;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: isUnlocked ? 1 : 0.4,
      child: GestureDetector(
        onTap: isUnlocked ? onTap : null,
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              /// Order Circle
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isUnlocked
                      ? const Color(0xFF6A66FF)
                      : Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  "${subtask.order}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              /// Title & Description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subtask.title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      subtask.description,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),

              /// Status Icon
              if (!isUnlocked)
                const Icon(Icons.lock, color: Colors.grey)
              else if (isCompleted)
                const Icon(Icons.check_circle, color: Colors.green)
              else
                const Icon(Icons.play_circle_fill, color: Color(0xFF6A66FF)),
            ],
          ),
        ),
      ),
    );
  }
}
