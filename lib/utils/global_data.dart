// user data
class UserData {
  final bool loginSuccess;
  final User user;

  UserData({required this.loginSuccess, required this.user});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      loginSuccess: json['loginSuccess'],
      user: User.fromJson(json['user']),
    );
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final int score;
  final int role;
  final int userId;
  final int v;
  final String token;
  final int liked;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.score,
    required this.role,
    required this.userId,
    required this.v,
    required this.token,
    required this.liked,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      score: json['score'],
      role: json['role'],
      userId: json['userId'],
      v: json['__v'],
      token: json['token'],
      liked: json['liked'],
    );
  }
}
