class Champion {
  final int id;
  final String name;
  final String role;
  final String description;

  Champion({
    required this.id,
    required this.name,
    required this.role,
    required this.description,
  });

  factory Champion.fromMap(Map<String, dynamic> json) {
    return Champion(
      id: json['id'],
      name: json['name'],
      role: json['role'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'description': description,
    };
  }
}
