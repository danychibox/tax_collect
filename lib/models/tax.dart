class Tax {
  final String id;
  final String name;
  final double amount;
  final DateTime? dueDate;
  final String? description;
  final DateTime createdAt;

  Tax({
    required this.id,
    required this.name,
    required this.amount,
    this.dueDate,
    this.description,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'dueDate': dueDate?.toIso8601String(),
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Tax.fromMap(Map<String, dynamic> map) {
    return Tax(
      id: map['id'],
      name: map['name'],
      amount: map['amount'],
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      description: map['description'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}