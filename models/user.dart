class User {
  final int? id;
  final String email;
  final String password;
  final String fullName;
  final String phoneNumber;
  final DateTime dob;
  final String gender;
  final DateTime createdAt;

  User({
    this.id,
    required this.email,
    required this.password,
    required this.fullName,
    required this.createdAt,
    required this.phoneNumber,
    required this.dob,
    required this.gender,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'full_name': fullName,
      'created_at': createdAt.millisecondsSinceEpoch,
      'phone_number': phoneNumber,
      'dob': dob.millisecondsSinceEpoch,
      'gender': gender
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      password: map['password'],
      fullName: map['full_name'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
      phoneNumber: map['phone_number'],
      dob: DateTime.fromMillisecondsSinceEpoch(map['dob']),
      gender: map['gender'],
    );
  }
}
