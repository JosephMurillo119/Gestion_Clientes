class Cliente {
  final String id;
  final String name;
  final String lastName;
  final int age;
  final String identification;

  Cliente({
    required this.id,
    required this.name,
    required this.lastName,
    required this.age,
    required this.identification,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'lastName': lastName,
      'age': age,
      'identification': identification,
    };
  }

  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      id: map['id'],
      name: map['name'],
      lastName: map['lastName'],
      age: map['age'],
      identification: map['identification'],
    );
  }
}
