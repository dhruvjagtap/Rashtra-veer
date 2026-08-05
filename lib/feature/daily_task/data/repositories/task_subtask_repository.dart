import '../models/task_subtask_model.dart';
import '../services/task_subtask_service.dart';

class TaskSubtaskRepository {
  final TaskSubtaskService _service = TaskSubtaskService();

  /// Create a new subtask
  Future<void> createSubTask(TaskSubtaskModel subtask) {
    return _service.createSubTask(subtask);
  }

  /// Stream all subtasks of a task
  Stream<List<TaskSubtaskModel>> streamSubTasks(String taskId) {
    return _service.streamSubTasks(taskId);
  }

  /// Mark a subtask as completed
  Future<void> markSubTaskCompleted({
    required String taskId,
    required String subtaskId,
  }) {
    return _service.markSubTaskCompleted(taskId: taskId, subtaskId: subtaskId);
  }

  /// Unlock the next subtask
  Future<void> unlockNextSubTask({
    required String taskId,
    required String currentSubtaskId,
  }) {
    return _service.unlockNextSubTask(
      taskId: taskId,
      currentSubtaskId: currentSubtaskId,
    );
  }

  /// Check if the parent task should be marked completed
  Future<void> checkTaskCompletion(String taskId) {
    return _service.checkTaskCompletion(taskId);
  }
}
