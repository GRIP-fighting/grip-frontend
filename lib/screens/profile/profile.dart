import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:madcamp_week4/screens/profile/edit_profile.dart';
import 'package:madcamp_week4/utils/global_colors.dart';

class ProfileView extends StatelessWidget{
  const ProfileView({Key? key, required this.userId, required this.authToken,}) : super(key: key);
  final String userId;
  final String authToken;

  @override
  Widget build(BuildContext context) {

    print('authToken: '+authToken);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalColors.mainColor,
        elevation: 0,
        foregroundColor: Colors.white.withOpacity(0.4),
        title: const Text(
          'Profile',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 30),
            child: Column(
              children: [
                // profile image + navigate to edit page
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/avatar.jpeg'),
                    ),
                    InkWell(
                      onTap: (){
                        Get.to(() => EditProfile());
                      },
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: GlobalColors.mainColor,
                        child: const Icon(
                          Icons.edit,
                          size: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                // name
                Text(
                  'Name',
                  style: TextStyle(
                    color: GlobalColors.textColor,
                    //fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 10,),
                // score
                Container(
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: GlobalColors.textColor.withOpacity(0.1),
                  ),
                  padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10,),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Score',
                        style: TextStyle(
                          color: GlobalColors.textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '점수',
                        style: TextStyle(
                          color: GlobalColors.textColor,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10,),
                  child: const Divider(),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10,),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: GlobalColors.textColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Text(
                            'Achieved Map',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10,),
                        FutureBuilder(
                            future: getAchievedMap(userId),
                            builder: (context, snapshot){
                              return const Text(
                                'test'
                              );
                            }
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

  Future<List<String>?> getAchievedMap(String id) async {
    getMapData(id);
  }

  Future<dynamic> getMapData(String id) async {
    String userId = Uri.encodeComponent(id);
    print('Encoded userId: $userId');
    try {
      final response = await http.get(Uri.parse('http://143.248.225.53:8000/api/users/$userId'),
          headers: {"Content-Type": "application/json"});
      print("Response body: ${response.body}");

      dynamic responseBody = jsonDecode(response.body);
      return responseBody;
    } catch (e) {
      print("Error: $e");
      return 'error';
    }
  }
}