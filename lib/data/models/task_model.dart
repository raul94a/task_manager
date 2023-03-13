// ignore_for_file: public_member_api_docs, sort_constructors_first

class Task {
  final String id;
  final String name;
  final String category;
  final String projectId;
  final int? timeInMillis;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Task({
    required this.id,
    required this.name,
    required this.category,
    required this.projectId,
    this.timeInMillis,
    this.status = "PENDING",
    required this.createdAt,
    required this.updatedAt,
  });

   Task copyWith({
    String? id,
    String? name,
    String? category,
    String? projectId,
    int? timeInMillis,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      projectId: projectId ?? this.projectId,
      timeInMillis: timeInMillis ?? this.timeInMillis,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Task.fromMap(Map<String, dynamic> map) => Task(
        id: map['id'],
        name: map['name'],
        category: map['category'],
        projectId: map['project_id'],
        timeInMillis: map['time_in_millis'],
        status: map['status'],
        createdAt: DateTime.parse(map['created_at']),
        updatedAt: DateTime.parse(map['updated_at']),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'category': category,
        'project_id': projectId,
        'time_in_millis': timeInMillis,
        'status': status,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  @override
  String toString() {
    return 'Task(id: $id, name: $name, category: $category, projectId: $projectId, timeInMillis: $timeInMillis, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
