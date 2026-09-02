class UserInfo {
  final String phone;
  final String email;
  final String name;
  final String userName;

  UserInfo({
    required this.name,
    required this.email,
    required this.phone,
    required this.userName,
  });

  UserInfo copyWith({
    String? phone,
    String? email,
    String? name,
    String? userName,
  }) {
    return UserInfo(
      name: name ?? this.name,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      phone: phone ?? this.phone,
    );
  }
}
