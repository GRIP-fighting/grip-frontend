import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:madcamp_week4/screens/users/user_detail.dart';
import 'package:madcamp_week4/service/network.dart';

import '../../models/global_data.dart';
import '../../util/global_colors.dart';

class UserRankView extends StatelessWidget{
  UserRankView({Key? key, required this.authToken}) : super(key: key);
  final String authToken;
  late final List<UserRankingData> _users;

  // for auth
  Map<String, String> headers = {};

  @override
  Widget build(BuildContext context) {
    Network network = Network(authToken: authToken);

    return Scaffold(
      backgroundColor: GlobalColors.mainColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: GlobalColors.mainColor,
        elevation: 0,
        foregroundColor: Colors.white.withOpacity(0.4),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            child: Column(
              children: [
                const Text(
                  'The most popular users at a glance!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    shadows: [
                      Shadow(
                        blurRadius: 8,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 10,),
                        FutureBuilder<List<UserRankingData>?> (
                          future: network.getUserData(),
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
                                  Color borderColor = Colors.white; // 기본값 설정
                                  if (index == 0) {
                                    borderColor = Color(0xFFD6B534); // 첫 번째 아이템에는 금색
                                  } else if (index == 1) {
                                    borderColor = Color(0xFFC0C0C0); // 두 번째 아이템에는 은색
                                  } else if (index == 2) {
                                    borderColor = Color(0xFFCD7F32); // 세 번째 아이템에는 동색
                                  }
                                  return Container(
                                      decoration: BoxDecoration(
                                        color: borderColor, // 전체 배경 색상 설정
                                        borderRadius: BorderRadius.circular(20.0), // 둥근 테두리 더 둥글게 설정
                                      ),
                                      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0), // 목록의 각 항목 간격 조정
                                      padding: EdgeInsets.symmetric(horizontal: 16.0), // 좌우 내부 패딩 조정
                                      // 목록의 각 항목 간격 조정
                                  child: ListTile(
                                      leading: FutureBuilder<String>(

                                        future: network.getUserImageUrl(user.userId), // 사용자의 이미지 URL을 가져오는 비동기 함수
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

}