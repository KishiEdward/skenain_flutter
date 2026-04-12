class UserModel {
  final int id;
  final String firebaseUid;
  final String email;
  final String name;
  final String role;
  final bool emailVerified;

  UserModel({
    required this.id,
    required this.firebaseUid,
    required this.email,
    required this.name,
    required this.role,
    required this.emailVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      firebaseUid: json['firebase_uid'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? 'user',
      emailVerified: json['email_verified'] ?? false,
    );
  }
}