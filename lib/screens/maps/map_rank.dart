import 'dart:convert';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:madcamp_week4/screens/maps/map_detail.dart';
import '../../utils/global_colors.dart';
import '../../utils/global_data.dart';

class MapRankView extends StatelessWidget{
  MapRankView({Key? key, required this.authToken}) : super(key: key);
  late List<MapRankingData> maps;
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
          'Map Ranking',
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
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Ranking Criteria: Number of Likes',
                            style: TextStyle(
                              color: GlobalColors.textColor,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        FutureBuilder<List<MapRankingData>?>(
                          future: getMapData(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text("Error: ${snapshot.error}");
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Text("No data available.");
                            } else {
                              List<MapRankingData> maps = snapshot.data!;

                              maps.sort((a, b) => b.liked.compareTo(a.liked));
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: maps.length,
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
                                        Get.to(() => MapDetailView(authToken: authToken, map: maps[index]));
                                      },
                                      child: ListTile(
                                        leading: const Icon(Icons.keyboard_arrow_right_outlined),
                                        title: Text("${index + 1}. ${maps[index].mapName}"),
                                        subtitle: Text('Level: ${maps[index].level}\n${maps[index].liked} Likes'),
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

  Future<List<MapRankingData>?> getMapData() async {
    // set cookie
    headers['cookie'] = "x_auth=$authToken";

    try {
      final response = await http.get(Uri.parse('http://143.248.225.53:8000/api/maps'), headers: headers);
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
}


