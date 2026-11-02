class UserModel {
  final String username;
  final String? email;
  final String? token;
  final bool isGuest;

  UserModel({
    required this.username,
    this.email,
    this.token,
    this.isGuest = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'token': token,
      'isGuest': isGuest,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'] ?? '',
      email: json['email'],
      token: json['token'],
      isGuest: json['isGuest'] ?? false,
    );
  }
}

