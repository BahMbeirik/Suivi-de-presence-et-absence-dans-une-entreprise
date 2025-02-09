class User {
  final int id;
  final String username;
  final String email;
  final String phoneNumber;
  final bool isPhoneVerified;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.isPhoneVerified,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      phoneNumber: json['phone_number'] ?? '',
      isPhoneVerified: json['is_phone_verified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'phone_number': phoneNumber,
      'is_phone_verified': isPhoneVerified,
    };
  }
}