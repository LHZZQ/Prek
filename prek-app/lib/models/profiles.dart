class Profiles {
  final String id;
  final String email;
  final DateTime createdAt;


Profiles({
  required this.id,
  required this.email,
  required this.createdAt,
});

factory Profiles.fromMap(Map<String, dynamic> map) {
    return Profiles(
      id: map['id'],
      email: map['email'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}