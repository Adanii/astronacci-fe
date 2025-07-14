import 'dart:developer';

class UserModel {
  final String? id;
  final String email;
  final String displayName;
  final String? password;
  final DateTime? createdAt;

  UserModel({
    this.id,
    required this.email,
    required this.displayName,
    this.password,
    this.createdAt,
  });

  Map<String, dynamic> toJsonLogin() {
    final map = {'email': email, 'password': password ?? ''};
    log('[UserModel.toJsonLogin] $map');
    return map;
  }

  Map<String, dynamic> toJsonRegister() {
    final map = {
      'email': email,
      'password': password ?? '',
      'displayName': displayName,
    };

    return map;
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'] ?? '',
      displayName: json['user_metadata']?['display_name'] ?? '',
      createdAt:
          json['created_at'] != null
              ? DateTime.tryParse(json['created_at'])
              : null,
    );
  }

  @override
  String toString() {
    return '{id: $id, email: $email, displayName: $displayName, password: $password, createdAt: $createdAt}';
  }
}
