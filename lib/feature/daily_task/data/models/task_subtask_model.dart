import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/tasks_status.dart';

class TaskSubtaskModel {
  final String id;
  final String taskId;
  final String title;
  final String description;
  final String videoId;
  final int order;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? completedAt;

  const TaskSubtaskModel({
    required this.id,
    required this.taskId,
    required this.title,
    required this.description,
    required this.videoId,
    required this.order,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
  });

  /// Create object from Firestore document
  factory TaskSubtaskModel.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;

    return TaskSubtaskModel(
      id: doc.id,
      taskId: data['taskId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      videoId: data['videoId'] ?? '',
      order: data['order'] ?? 0,
      status: data['status'] ?? TaskStatus.pending,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      completedAt: data['completedAt'] != null
          ? (data['completedAt'] as Timestamp).toDate()
          : null,
    );
  }

  /// Convert object to Firestore Map
  Map<String, dynamic> toMap() {
    return {
      'taskId': taskId,
      'title': title,
      'description': description,
      'videoId': videoId,
      'order': order,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'completedAt': completedAt != null
          ? Timestamp.fromDate(completedAt!)
          : null,
    };
  }

  /// Returns a new object with updated values
  TaskSubtaskModel copyWith({
    String? id,
    String? taskId,
    String? title,
    String? description,
    String? videoId,
    int? order,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
  }) {
    return TaskSubtaskModel(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      title: title ?? this.title,
      description: description ?? this.description,
      videoId: videoId ?? this.videoId,
      order: order ?? this.order,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  String toString() {
    return '''
TaskSubtaskModel(
  id: $id,
  taskId: $taskId,
  title: $title,
  videoId: $videoId,
  order: $order,
  status: $status
)
''';
  }
}
