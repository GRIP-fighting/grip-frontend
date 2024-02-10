import 'dart:convert';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../models/global_data.dart';
import '../screens/login/login.dart';

class Network {
  Network({required this.authToken});
  final baseUrl = "http://13.125.42.66:8000/api";
  final String authToken;

  Map<String, String> headers = {};

  // for map_detail.dart
  Future<void> updateLikedStatus(int mapId) async {
    try {
      headers['cookie'] = "x_auth=$authToken";

      final response = await http.patch(
        Uri.parse('$baseUrl/maps/$mapId/liked'),
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
      final response = await http.get(Uri.parse('$baseUrl/maps'), headers: headers);
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
      final response = await http.get(Uri.parse('$baseUrl/users/$userId'), headers: headers);
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
      final response = await http.get(Uri.parse('$baseUrl/users/$userId'), headers: headers);
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
      final response = await http.get(Uri.parse('$baseUrl/users/$userId'), headers: headers);
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
      final response = await http.get(Uri.parse('$baseUrl/users/$userId'), headers: headers);
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

  Future<Uint8List?> fetchImageData(int userId) async {
    // set cookie
    headers['cookie'] = "x_auth=$authToken";

    try {
      final response = await http.get(Uri.parse('$baseUrl/users/profileImage/$userId'), headers: headers);
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        print('Failed to load image');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<void> sendImageData(Uint8List imageData) async {
    try {
      var request = http.MultipartRequest(
        'PATCH',
        Uri.parse('$baseUrl/users/profileImage'),
      );

      request.files.add(http.MultipartFile.fromBytes(
        'profileImage',
        imageData,
        filename: 'image.jpg',
        contentType: MediaType('image', 'jpeg'),
      ));

      // set cookie
      request.headers['cookie'] = "x_auth=$authToken";

      var response = await request.send();
      var responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        print('Successfully uploaded the image');
      } else {
        print('Failed to upload image. Status code: ${response.statusCode}');
        print(responseData.body);
        throw Exception('Failed to upload image');
      }
    } catch (e) {
      print('Error uploading image: $e');
      throw Exception('Error uploading image');
    }
  }

  Future<void> logout() async{
    // set cookie
    headers['cookie'] = "x_auth=$authToken";

    try {
      final response = await http.get(Uri.parse('$baseUrl/users/logout'), headers: headers);
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
      final response = await http.delete(Uri.parse('$baseUrl/users/'), headers: headers);
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
    final String apiUrl = "$baseUrl/users/$userId";

    try {
      print(apiUrl);
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        String imageUrl = responseData['imageUrl'];
        print(imageUrl);
        return imageUrl;
      }
      print('Failed to load image URL: ${response.statusCode}');
      return '';
    } catch (e) {
      print('Error fetching user image URL: $e');
      return '';
    }
  }
  Future<List<UserRankingData>?> getUserData() async {
    // set cookie
    headers['cookie'] = "x_auth=$authToken";

    try {
      final response = await http.get(Uri.parse('$baseUrl/users'), headers: headers);
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