class User {
  final String id;
  final String name;
  final String location;
  final String gender;
  final String avatarUrl;
  final bool isOnline;

  User({
    required this.id,
    required this.name,
    required this.location,
    required this.gender,
    required this.avatarUrl,
    required this.isOnline
  });
}