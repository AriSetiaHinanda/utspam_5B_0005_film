class User {
  final int? id;
  final String fullName;
  final String email;
  final String address;
  final String phoneNumber;
  final String username;
  final String password;
  final DateTime createdAt;

  User({
    this.id,
    required this.fullName,
    required this.email,
    required this.address,
    required this.phoneNumber,
    required this.username,
    required this.password,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'address': address,
      'phone_number': phoneNumber,
      'username': username,
      'password': password,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      fullName: map['full_name'],
      email: map['email'],
      address: map['address'],
      phoneNumber: map['phone_number'],
      username: map['username'],
      password: map['password'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
  
  User copyWith({
    int? id,
    String? fullName,
    String? email,
    String? address,
    String? phoneNumber,
    String? username,
    String? password,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      username: username ?? this.username,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}