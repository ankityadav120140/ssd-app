class User {
  final String id;
  final String name;
  final String mobile;
  final String apiToken;

  User({
    required this.id,
    required this.name,
    required this.mobile,
    required this.apiToken,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      name: json['name'] ?? "User",
      mobile: json['mobile'].toString(),
      apiToken: json['api_token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'mobile': mobile,
      'api_token': apiToken,
    };
  }
}
