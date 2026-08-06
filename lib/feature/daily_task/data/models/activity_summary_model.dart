class ActivitySummaryModel {
  final int totalTasks;
  final int completedTasks;
  final int totalPoints;
  final int earnedPoints;
  final int streak;

  const ActivitySummaryModel({
    required this.totalTasks,
    required this.completedTasks,
    required this.totalPoints,
    required this.earnedPoints,
    required this.streak,
  });

  double get progress => totalTasks == 0 ? 0 : completedTasks / totalTasks;
}
