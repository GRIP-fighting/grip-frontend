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

// map data
class Solution {
  String id;
  int mapId;
  int liked;
  int evaluatedLevel;
  String solutionPath;
  int userId;
  int solutionId;

  Solution({
    required this.id,
    required this.mapId,
    required this.liked,
    required this.evaluatedLevel,
    required this.solutionPath,
    required this.userId,
    required this.solutionId,
  });

  factory Solution.fromJson(Map<String, dynamic> json) {
    return Solution(
      id: json['_id'],
      mapId: json['mapId'],
      liked: json['liked'],
      evaluatedLevel: json['evaluatedLevel'],
      solutionPath: json['solutionPath'],
      userId: json['userId'],
      solutionId: json['solutionId'],
    );
  }

  @override
  String toString() {
    return 'Solution(id: $id, mapId: $mapId, liked: $liked, evalutedLevel: $evaluatedLevel, solutionPath: $solutionPath, userId: $userId, solutionId: $solutionId)';
  }
}

class LikedMap {
  String id;
  String mapName;
  String mapPath;
  int level;
  int liked;
  List<int> designer;
  List<int> solutionId;
  int mapId;
  int version;

  LikedMap({
    required this.id,
    required this.mapName,
    required this.mapPath,
    required this.level,
    required this.liked,
    required this.designer,
    required this.solutionId,
    required this.mapId,
    required this.version,
  });

  factory LikedMap.fromJson(Map<String, dynamic> json) {
    return LikedMap(
      id: json['_id'],
      mapName: json['mapName'],
      mapPath: json['mapPath'],
      level: json['level'],
      liked: json['liked'],
      designer: List<int>.from(json['designer']),
      solutionId: List<int>.from(json['solutionId']),
      mapId: json['mapId'],
      version: json['__v'],
    );
  }
}

class LikedSolution {
  String id;
  int mapId;
  int liked;
  int evaluatedLevel;
  String solutionPath;
  int userId;
  int solutionId;
  int version;

  LikedSolution({
    required this.id,
    required this.mapId,
    required this.liked,
    required this.evaluatedLevel,
    required this.solutionPath,
    required this.userId,
    required this.solutionId,
    required this.version,
  });

  factory LikedSolution.fromJson(Map<String, dynamic> json) {
    return LikedSolution(
      id: json['_id'],
      mapId: json['mapId'],
      liked: json['liked'],
      evaluatedLevel: json['evaluatedLevel'],
      solutionPath: json['solutionPath'],
      userId: json['userId'],
      solutionId: json['solutionId'],
      version: json['__v'],
    );
  }
}

class MapData {
  String id;
  String mapName;
  String mapPath;
  int level;
  int liked;
  List<int> designer;
  List<int> solutionId;
  int mapId;
  int version;

  MapData({
    required this.id,
    required this.mapName,
    required this.mapPath,
    required this.level,
    required this.liked,
    required this.designer,
    required this.solutionId,
    required this.mapId,
    required this.version,
  });

  factory MapData.fromJson(Map<String, dynamic> json) {
    return MapData(
      id: json['_id'],
      mapName: json['mapName'],
      mapPath: json['mapPath'],
      level: json['level'],
      liked: json['liked'],
      designer: List<int>.from(json['designer']),
      solutionId: List<int>.from(json['solutionId']),
      mapId: json['mapId'],
      version: json['__v'],
    );
  }
}


