import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/tasks_status.dart';
import '../models/task_subtask_model.dart';
import 'daily_task_service.dart';

class TaskSubtaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //////////////////////////////////////////////////////////////
  /// Returns subtask collection of a task
  //////////////////////////////////////////////////////////////

  CollectionReference<Map<String, dynamic>> _subtaskCollection(String taskId) {
    return _firestore
        .collection('assigned_tasks')
        .doc(taskId)
        .collection('subtasks');
  }

  //////////////////////////////////////////////////////////////
  /// Create a subtask
  //////////////////////////////////////////////////////////////

  Future<void> createSubTask(TaskSubtaskModel subtask) async {
    try {
      await _subtaskCollection(subtask.taskId).add(subtask.toMap());
    } on FirebaseException catch (e) {
      throw Exception("Failed to create subtask: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  //////////////////////////////////////////////////////////////
  /// Stream subtasks
  //////////////////////////////////////////////////////////////

  Stream<List<TaskSubtaskModel>> streamSubTasks(String taskId) {
    return _subtaskCollection(taskId)
        .orderBy('order')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => TaskSubtaskModel.fromDocument(doc))
              .toList(),
        );
  }

  //////////////////////////////////////////////////////////////
  /// Mark subtask completed
  //////////////////////////////////////////////////////////////

  Future<void> markSubTaskCompleted({
    required String taskId,
    required String subtaskId,
  }) async {
    try {
      await _subtaskCollection(taskId).doc(subtaskId).update({
        'status': TaskStatus.completed,
        'completedAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      });

      await unlockNextSubTask(taskId: taskId, currentSubtaskId: subtaskId);

      await checkTaskCompletion(taskId);
    } on FirebaseException catch (e) {
      throw Exception("Failed to complete subtask: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  //////////////////////////////////////////////////////////////
  /// Unlock next subtask
  //////////////////////////////////////////////////////////////

  Future<void> unlockNextSubTask({
    required String taskId,
    required String currentSubtaskId,
  }) async {
    try {
      final snapshot = await _subtaskCollection(taskId).orderBy('order').get();

      final docs = snapshot.docs;

      final currentIndex = docs.indexWhere((doc) => doc.id == currentSubtaskId);

      if (currentIndex == -1) return;

      if (currentIndex == docs.length - 1) return;

      final nextDoc = docs[currentIndex + 1];

      final data = nextDoc.data();

      if (data['status'] == TaskStatus.locked) {
        await nextDoc.reference.update({
          'status': TaskStatus.pending,
          'updatedAt': Timestamp.now(),
        });
      }
    } on FirebaseException catch (e) {
      throw Exception("Failed to unlock next subtask: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  //////////////////////////////////////////////////////////////
  /// Check whether parent task is complete
  //////////////////////////////////////////////////////////////

  Future<void> checkTaskCompletion(String taskId) async {
    try {
      final snapshot = await _subtaskCollection(taskId).get();

      final allCompleted = snapshot.docs.every(
        (doc) => doc['status'] == TaskStatus.completed,
      );

      if (allCompleted) {
        await DailyTaskService().markCompleted(taskId);
      }
    } on FirebaseException catch (e) {
      throw Exception("Failed to check task completion: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
