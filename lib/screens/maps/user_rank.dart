import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:madcamp_week4/screens/maps/user_detail.dart';
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
                        FutureBuilder<List<UserRankingData>?>(
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
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: _users.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: GlobalColors.textColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        print('ListTile clicked');
                                        Get.to(() => UserDetailView(authToken: authToken, user: _users[index]));
                                      },
                                      child: ListTile(
                                        leading: const Icon(Icons.keyboard_arrow_right_outlined),
                                        title: Text("${index+1}. ${_users[index].name}"),
                                        subtitle: Text('Score: ${_users[index].score}\n'
                                            'got ${_users[index].liked} Likes'),
                                      ),
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