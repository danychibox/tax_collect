class Taxpayer {
  final String id;
  final String name;
  final String? address;
  final String? phone;
  final String? email;
  final DateTime createdAt;

  Taxpayer({
    required this.id,
    required this.name,
    this.address,
    this.phone,
    this.email,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'email': email,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Taxpayer.fromMap(Map<String, dynamic> map) {
    return Taxpayer(
      id: map['id'],
      name: map['name'],
      address: map['address'],
      phone: map['phone'],
      email: map['email'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}