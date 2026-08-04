import 'package:cloud_firestore/cloud_firestore.dart';

// import '../constants/task_category.dart';
// import '../constants/task_difficulty.dart';
// import '../constants/task_status.dart';
import '../models/daily_task_model.dart';

class DailyTaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _taskCollection =>
      _firestore.collection('assigned_tasks');

  /// Create a single task
  Future<void> createTask(DailyTaskModel task) async {
    try {
      await _taskCollection.add(task.toMap());
    } on FirebaseException catch (e) {
      throw Exception("Failed to create task: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  /// Temporary method for testing
  Future<void> seedDummyTasks({
    required String userId,
    required String trainerId,
  }) async {
    try {
      final now = DateTime.now();

      final tasks = [
        DailyTaskModel(
          id: '',
          assignedTo: userId,
          trainerId: trainerId,
          title: "Morning Walk",
          description: "Walk continuously for 30 minutes",
          category: "Workout",
          difficulty: "Easy",
          points: 20,
          status: "pending",
          assignedDate: now,
          dueDate: now.add(const Duration(hours: 12)),
          completedAt: null,
          createdAt: now,
          updatedAt: now,
        ),

        DailyTaskModel(
          id: '',
          assignedTo: userId,
          trainerId: trainerId,
          title: "Meditation",
          description: "Meditate peacefully for 15 minutes",
          category: "Meditation",
          difficulty: "Easy",
          points: 15,
          status: "pending",
          assignedDate: now,
          dueDate: now.add(const Duration(hours: 12)),
          completedAt: null,
          createdAt: now,
          updatedAt: now,
        ),

        DailyTaskModel(
          id: '',
          assignedTo: userId,
          trainerId: trainerId,
          title: "Healthy Breakfast",
          description: "Eat a protein-rich breakfast",
          category: "Diet",
          difficulty: "Easy",
          points: 10,
          status: "pending",
          assignedDate: now,
          dueDate: now.add(const Duration(hours: 12)),
          completedAt: null,
          createdAt: now,
          updatedAt: now,
        ),

        DailyTaskModel(
          id: '',
          assignedTo: userId,
          trainerId: trainerId,
          title: "Drink Water",
          description: "Drink at least 3 litres of water",
          category: "Diet",
          difficulty: "Easy",
          points: 10,
          status: "pending",
          assignedDate: now,
          dueDate: now.add(const Duration(hours: 12)),
          completedAt: null,
          createdAt: now,
          updatedAt: now,
        ),

        DailyTaskModel(
          id: '',
          assignedTo: userId,
          trainerId: trainerId,
          title: "Stretching",
          description: "Complete 10 minutes of stretching",
          category: "Workout",
          difficulty: "Easy",
          points: 15,
          status: "pending",
          assignedDate: now,
          dueDate: now.add(const Duration(hours: 12)),
          completedAt: null,
          createdAt: now,
          updatedAt: now,
        ),
      ];

      for (final task in tasks) {
        await createTask(task);
      }
    } on FirebaseException catch (e) {
      throw Exception("Failed to seed dummy tasks: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  /// Fetch today's tasks for a user
  Stream<List<DailyTaskModel>> streamTodayTasks(String userId)  {

    final now = DateTime.now();

    final startOfDay = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final endOfDay = DateTime(
      now.year,
      now.month,
      now.day,
      23,
      59,
      59,
    );

    return _taskCollection
      .where('assignedTo', isEqualTo: userId)
      .where(
        'assignedDate',
        isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
      )
      .where(
        'assignedDate',
        isLessThanOrEqualTo: Timestamp.fromDate(endOfDay),
      )
      .orderBy('assignedDate')
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
        .map((doc) => DailyTaskModel.fromDocument(doc))
        .toList(),
      );

  }
}