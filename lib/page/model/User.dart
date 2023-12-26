class User {
  final String name;
  final String email;
  final String address;
  final String phone;
  final String password;
  final bool isAdmin;
  User({
    required this.name,
    required this.email,
    required this.address,
    required this.phone,
    required this.password,
    required this.isAdmin,

  });

  factory User.fromJsonDB(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      address: json['address'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      password: json['password'] as String? ?? '',
      isAdmin: json['isAdmin'] == '1', // Modify the type casting here
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'address': address,
      'phone': phone,
      'password': password,
      'isAdmin': isAdmin ? '1' : '0',

    };
  }

  Map<String, dynamic> toJsonForDelete() {
    return {
      'email': email,
    };
  }
  Map<String, dynamic> toJsonForUpdate(String oldEmail) {
    return {
      'name': name,
      'newEmail': email,
      'email':oldEmail,
      'address': address,
      'phone': phone,
      'password': password,
      'isAdmin': isAdmin ? '1' : '0',
    };
  }
}