import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

import '../models/global_data.dart';
import '../screens/login/login.dart';

class Network {
  Network({required this.authToken});
  final baseUrl = "http://13.125.42.66:8000";
  final String authToken;

  Map<String, String> headers = {};

  // for map_detail.dart
  Future<void> updateLikedStatus(int mapId) async {
    try {
      headers['cookie'] = "x_auth=$authToken";

      final response = await http.patch(
        Uri.parse('$baseUrl/api/maps/$mapId/liked'),
        headers: headers,
      );

      print('updateLike response: ${response.body}');
      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('Liked status updated successfully');

        // setState(() {
        //   widget.map.likedUserId.contains(widget.user.userId)
        //       ? widget.map.likedUserId.remove(widget.user.userId)
        //       : widget.map.likedUserId.add(widget.user.userId);
        // });
      } else {
        print('Error updating liked status. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating liked status: $e');
    }
  }

  // for map_rank.dart
  Future<List<MapRankingData>?> getMapData() async {
    // set cookie
    headers['cookie'] = "x_auth=$authToken";

    try {
      final response = await http.get(Uri.parse('$baseUrl/api/maps'), headers: headers);
      print("getMapData Response body: ${response.body}");

      if (response.statusCode == 200) {
        dynamic responseBody = json.decode(response.body);

        if (responseBody is Map && responseBody.containsKey('maps')) {
          List<MapRankingData> maps = (responseBody['maps'] as List).map((json) => MapRankingData.fromJson(json)).toList();
          print('getMapData solutions: $maps');
          return maps;
        } else {
          print("getMapData Error - Unexpected response format");
          return null;
        }
      } else {
        print("getMapData Error - Status Code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("getMapData Error: $e");
      return null;
    }
  }

  // for profile.dart
  Future<List<MapData>?> getMyMapData(int id) async {
    String userId = jsonEncode(id);

    // set cookie
    headers['cookie'] = "x_auth=$authToken";

    try {
      final response = await http.get(Uri.parse('$baseUrl/api/users/$userId'), headers: headers);
      print("getMyMapData Response body: ${response.body}");

      if (response.statusCode == 200) {
        dynamic responseBody = json.decode(response.body);

        if (responseBody is Map && responseBody.containsKey('maps')) {
          List<MapData> maps = (responseBody['maps'] as List).map((json) => MapData.fromJson(json)).toList();
          print('getMyMapData solutions: $maps');
          return maps;
        } else {
          print("getMyMapData Error - Unexpected response format");
          return null;
        }
      } else {
        print("getMyMapData Error - Status Code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("getMyMapData Error: $e");
      return null;
    }
  }

  Future<List<Solution>?> getAchievedMapData(int id) async {
    String userId = jsonEncode(id);

    // set cookie
    headers['cookie'] = "x_auth=$authToken";

    try {
      final response = await http.get(Uri.parse('$baseUrl/api/users/$userId'), headers: headers);
      print("getAchievedMapData Response body: ${response.body}");

      if (response.statusCode == 200) {
        dynamic responseBody = json.decode(response.body);

        if (responseBody is Map && responseBody.containsKey('solutions')) {
          List<Solution> solutions = (responseBody['solutions'] as List).map((json) => Solution.fromJson(json)).toList();
          print('getAchievedMapData solutions: $solutions');
          return solutions;
        } else {
          print("getAchievedMapData Error - Unexpected response format");
          return null;
        }
      } else {
        print("getAchievedMapData Error - Status Code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("getAchievedMapData Error: $e");
      return null;
    }
  }

  Future<List<LikedMap>?> getLikedMapData(int id) async {
    String userId = jsonEncode(id);

    // set cookie
    headers['cookie'] = "x_auth=$authToken";

    try {
      final response = await http.get(Uri.parse('$baseUrl/api/users/$userId'), headers: headers);
      print("getLikedMapData Response body: ${response.body}");

      if (response.statusCode == 200) {
        dynamic responseBody = json.decode(response.body);

        if (responseBody is Map && responseBody.containsKey('likedMaps')) {
          List<LikedMap> likedMaps = (responseBody['likedMaps'] as List).map((json) => LikedMap.fromJson(json)).toList();
          print('getLikedMapData: $likedMaps');
          return likedMaps;
        } else {
          print("geLikedMapData Error - Unexpected response format");
          return null;
        }
      } else {
        print("getLikedMapData Error - Status Code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("getLikedMapData Error: $e");
      return null;
    }
  }

  Future<List<LikedSolution>?> getLikedSolutionData(int id) async {
    String userId = jsonEncode(id);

    // set cookie
    headers['cookie'] = "x_auth=$authToken";

    try {
      final response = await http.get(Uri.parse('$baseUrl/api/users/$userId'), headers: headers);
      print("getLikedSolutionData Response body: ${response.body}");

      if (response.statusCode == 200) {
        dynamic responseBody = json.decode(response.body);

        if (responseBody is Map && responseBody.containsKey('likedSolutions')) {
          List<LikedSolution> likedSolutions = (responseBody['likedSolutions'] as List).map((json) => LikedSolution.fromJson(json)).toList();
          print('getLikedSolutionData: $likedSolutions');
          return likedSolutions;
        } else {
          print("geLikedSolutionData Error - Unexpected response format");
          return null;
        }
      } else {
        print("getLikedSolutionData Error - Status Code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("getLikedSolutionData Error: $e");
      return null;
    }
  }



  Future<void> logout() async{
    // set cookie
    headers['cookie'] = "x_auth=$authToken";

    try {
      final response = await http.get(Uri.parse('$baseUrl/api/users/logout'), headers: headers);
      print("Logout Response body: ${response.body}");

      if (response.statusCode == 200) {
        dynamic responseBody = json.decode(response.body);

        if (responseBody is Map && responseBody.containsKey('success')) {
          if(responseBody['success']){
            Get.to(() => LoginView());
          }
        } else {
          print("Logout Error - Unexpected response format");
        }
      } else {
        print("Logout Error - Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Logout Error: $e");
    }
  }

  Future<void> deleteAccount() async{
    // set cookie
    headers['cookie'] = "x_auth=$authToken";

    try {
      final response = await http.delete(Uri.parse('$baseUrl/api/users/'), headers: headers);
      print("Deleting Response body: ${response.body}");

      if (response.statusCode == 200) {
        Get.to(() => LoginView());
      } else {
        print("Deleting Error - Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Deleting Error: $e");
    }
  }

  // for user_rank.dart
  Future<String> getUserImageUrl(int userId) async {
    final String apiUrl = "$baseUrl/api/users/$userId"; // 사용자 이미지 URL을 가져오는 API 엔드포인트

    try {
      print(apiUrl);
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        String imageUrl = responseData['imageUrl']; // 서버 응답에서 이미지 URL을 추출
        print(imageUrl);
        return imageUrl;
      }
      print('Failed to load image URL: ${response.statusCode}');
      return '';
    } catch (e) {
      print('Error fetching user image URL: $e');
      return ''; // 기본 이미지 URL을 반환
    }
  }
  Future<List<UserRankingData>?> getUserData() async {
    // set cookie
    headers['cookie'] = "x_auth=$authToken";

    try {
      final response = await http.get(Uri.parse('$baseUrl/api/users'), headers: headers);
      print("getUserData Response body: ${response.body}");

      if (response.statusCode == 200) {
        dynamic responseBody = json.decode(response.body);

        if (responseBody is Map && responseBody.containsKey('users')) {
          List<UserRankingData> users = (responseBody['users'] as List).map((json) => UserRankingData.fromJson(json)).toList();
          print('getUserData: $users');
          return users;
        } else {
          print("getUserData Error - Unexpected response format");
          return null;
        }
      } else {
        print("getUserData Error - Status Code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("getUserData Error: $e");
      return null;
    }
  }
}