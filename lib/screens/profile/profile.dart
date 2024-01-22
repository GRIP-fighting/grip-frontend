import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:madcamp_week4/screens/profile/edit_profile.dart';
import 'package:madcamp_week4/utils/global_colors.dart';

import '../../utils/global_data.dart';

class ProfileView extends StatelessWidget{
  ProfileView({Key? key, required this.user, required this.authToken}) : super(key: key);
  final User user;
  final String authToken;

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
                  user.name,
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
                        '${user.score}',
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
                            future: getAchievedMap(user.userId),
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

  Future<List<String>?> getAchievedMap(int id) async {
    dynamic response = getMapData(id);


  }

  Future<dynamic> getMapData(int id) async {

    String userId = jsonEncode(id);

    // set cookie
    headers['cookie'] = "x_auth=$authToken";

    try {
      final response = await http.get(Uri.parse('http://143.248.225.53:8000/api/users/$userId'),
          headers: headers);
      print("getMapData Response body: ${response.body}");

      dynamic responseBody = jsonDecode(response.body);
      return responseBody;
    } catch (e) {
      print("Error: $e");
      return 'error';
    }
  }
}