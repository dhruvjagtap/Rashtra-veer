
// UI

// ↓

// Repository

// ↓

// Firestore Service

// ↓

// Firestore

import '../models/daily_task_model.dart';
import '../services/daily_task_service.dart';

class DailyTaskRepository {
  final DailyTaskService _service = DailyTaskService();

  Stream<List<DailyTaskModel>> streamTodayTasks(String userId) {
    return _service.streamTodayTasks(userId);
  }
}