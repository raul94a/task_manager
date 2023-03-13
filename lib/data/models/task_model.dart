
class Task {
  final int id;
  final String name;
  final String category;
  final int projectId;
  final int? timeInMillis;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Task({
    this.id = -1,
    required this.name,
    required this.category,
    required this.projectId,
    this.timeInMillis,
    this.status = "PENDING",
    required this.createdAt,
    required this.updatedAt,
  });

   Task copyWith({
    int? id,
    String? name,
    String? category,
    int? projectId,
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
}
