import 'package:cloud_firestore/cloud_firestore.dart';

// import '../constants/task_status.dart';

class DailyTaskModel {
  final String id;
  final String assignedTo;
  final String trainerId;
  final String title;
  final String description;
  final String category;
  final String difficulty;
  final int points;
  final String status;
  final DateTime assignedDate;
  final DateTime dueDate;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DailyTaskModel({
    required this.id,
    required this.assignedTo,
    required this.trainerId,
    required this.title,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.points,
    required this.status,
    required this.assignedDate,
    required this.dueDate,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a model from a Firestore document.
  factory DailyTaskModel.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();

    if (data == null) {
      throw Exception("Task document does not exist.");
    }

    return DailyTaskModel(
      id: doc.id,
      assignedTo: data['assignedTo'] ?? '',
      trainerId: data['trainerId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      difficulty: data['difficulty'] ?? '',
      points: (data['points'] ?? 0) as int,
      status: data['status'] ?? 'pending',
      assignedDate:
          (data['assignedDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      dueDate: (data['dueDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      completedAt: (data['completedAt'] as Timestamp?)?.toDate(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Converts this model into a Firestore document.
  Map<String, dynamic> toMap() {
    return {
      'assignedTo': assignedTo,
      'trainerId': trainerId,
      'title': title,
      'description': description,
      'category': category,
      'difficulty': difficulty,
      'points': points,
      'status': status,
      'assignedDate': Timestamp.fromDate(assignedDate),
      'dueDate': Timestamp.fromDate(dueDate),
      'completedAt': completedAt != null
          ? Timestamp.fromDate(completedAt!)
          : null,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Returns a copy of this model with updated values.
  DailyTaskModel copyWith({
    String? id,
    String? assignedTo,
    String? trainerId,
    String? title,
    String? description,
    String? category,
    String? difficulty,
    int? points,
    String? status,
    DateTime? assignedDate,
    DateTime? dueDate,
    DateTime? completedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DailyTaskModel(
      id: id ?? this.id,
      assignedTo: assignedTo ?? this.assignedTo,
      trainerId: trainerId ?? this.trainerId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      points: points ?? this.points,
      status: status ?? this.status,
      assignedDate: assignedDate ?? this.assignedDate,
      dueDate: dueDate ?? this.dueDate,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return '''
DailyTaskModel(
  id: $id,
  title: $title,
  assignedTo: $assignedTo,
  trainerId: $trainerId,
  category: $category,
  difficulty: $difficulty,
  status: $status,
  points: $points,
  assignedDate: $assignedDate,
  dueDate: $dueDate,
)
''';
  }
}
