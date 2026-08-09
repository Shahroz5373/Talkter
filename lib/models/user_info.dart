class UserInfo {
  final String phone;
  final String email;
  final String name;

  UserInfo({required this.name, required this.email, required this.phone});

  UserInfo copyWith({String? phone, String? email, String? name}) {
    return UserInfo(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }
}
