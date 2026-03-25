import 'package:flutter/material.dart';

/// Dummy task model for UI.
class TaskItem {
  const TaskItem({
    required this.name,
    required this.isCompleted,
  });

  final String name;
  final bool isCompleted;
}

/// Today's task section with progress and task list.
class TodaysTaskSection extends StatelessWidget {
  const TodaysTaskSection({super.key});

  static final List<TaskItem> _dummyTasks = const [
    TaskItem(name: '500m Running', isCompleted: true),
    TaskItem(name: '20 Push ups', isCompleted: true),
    TaskItem(name: '60 sec Jumping jacks', isCompleted: false),
  ];

  @override
  Widget build(BuildContext context) {
    final completedCount = _dummyTasks.where((t) => t.isCompleted).length;
    final totalCount = _dummyTasks.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Today's Task",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                '$completedCount/$totalCount',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: _dummyTasks
                .map(
                  (task) => _TaskTile(
                    name: task.name,
                    isCompleted: task.isCompleted,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({
    required this.name,
    required this.isCompleted,
  });

  final String name;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isCompleted ? const Color(0xFF7F7BFF) : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: const Color(0xFF7F7BFF),
                width: 2,
              ),
            ),
            child: isCompleted
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isCompleted ? Colors.grey.shade600 : Colors.black87,
                decoration: isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
