import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:madcamp_week4/screens/users/user_detail.dart';
import '../../utils/global_colors.dart';
import '../../utils/global_data.dart';

class UserRankView extends StatelessWidget{
  UserRankView({Key? key, required this.authToken}) : super(key: key);
  final String authToken;
  late final List<UserRankingData> _users;

  // for auth
  Map<String, String> headers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: GlobalColors.mainColor,
        elevation: 0,
        foregroundColor: Colors.white.withOpacity(0.4),
        centerTitle: true,
        title: const Text(
          'User Ranking',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: GlobalColors.textColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 10,),
                        FutureBuilder<List<UserRankingData>?> (
                          future: getUserData(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text("Error: ${snapshot.error}");
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Text("No data available.");
                            } else {
                              _users = snapshot.data!;
                              _users.sort((a, b) => b.liked.compareTo(a.liked));

                              return ListView.builder (
                                shrinkWrap: true,
                                itemCount: _users.length,
                                itemBuilder: (context, index) {
                                  final user = _users[index];
                                  Color borderColor;
                                  if (index == 0) {
                                    borderColor = Colors.yellow; // 첫 번째 아이템에는 금색
                                  } else if (index == 1) {
                                    borderColor = Colors.grey; // 두 번째 아이템에는 은색
                                  } else if (index == 2) {
                                    borderColor = Colors.brown; // 세 번째 아이템에는 동색
                                  } else {
                                    borderColor = Colors.transparent; // 나머지 아이템에는 테두리 없음
                                  }
                                  return Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: borderColor),
                                        borderRadius: BorderRadius.circular(4.0), // 원하는 만큼의 둥근 테두리
                                      ),
                                      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0), // 목록의 각 항목 간격 조정
                                  child: ListTile(
                                      leading: FutureBuilder<String>(

                                        future: getUserImageUrl(user.userId), // 사용자의 이미지 URL을 가져오는 비동기 함수
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            // 데이터를 기다리는 동안 로딩 표시자를 보여줌
                                            return CircularProgressIndicator();
                                          } else if (snapshot.hasError) {
                                            return Icon(Icons.error);
                                          } else {
                                            if(snapshot.data == '')
                                              return Icon(Icons.error);
                                            return CircleAvatar(
                                              backgroundImage: NetworkImage(snapshot.data!), // 네트워크에서 이미지 로드
                                              radius: 20, // 원형 이미지의 반지름 설정
                                            );
                                          }
                                        },
                                      ),
                                      title: Text("${index + 1}. ${user.name}"),
                                      subtitle: Text('Score: ${user.score}\n'
                                          'Likes: ${user.liked}'),
                                      onTap: () {
                                        print('ListTile clicked');
                                        Get.to(() => UserDetailView(authToken: authToken, user: _users[index]));
                                      },
                                      contentPadding: EdgeInsets.all(0), // ListTile의 내부 패딩을 0으로 설정
                                      tileColor: Colors.transparent, // ListTile의 배경색을 투명하게 설정
                                    )
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<String> getUserImageUrl(int userId) async {
    final String apiUrl = "http://143.248.225.53:8000/api/users/$userId"; // 사용자 이미지 URL을 가져오는 API 엔드포인트

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
      final response = await http.get(Uri.parse('http://143.248.225.53:8000/api/users'), headers: headers);
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