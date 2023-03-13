class Project {
  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  Project({
    this.id = -1,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });
  
  Project copyWith({
    int? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Project.fromMap(Map<String, dynamic> map) => Project(
        id: map['id'],
        name: map['name'],
        createdAt: DateTime.parse(map['created_at']),
        updatedAt: DateTime.parse(map['updated_at']),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };
}
