import 'dart:convert';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:madcamp_week4/screens/maps/map_detail.dart';
import '../../utils/global_colors.dart';
import '../../utils/global_data.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MapRankView extends StatefulWidget{
  MapRankView({Key? key, required this.authToken, required this.user}) : super(key: key);
  final String authToken;
  final User user;

  @override
  State<MapRankView> createState() => _MapRankViewState();
}

class _MapRankViewState extends State<MapRankView> {
  late List<MapRankingData> maps;

  // for auth
  Map<String, String> headers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.mainColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: GlobalColors.mainColor,
        elevation: 0,
        foregroundColor: Colors.white.withOpacity(0.4),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SafeArea(
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'The most popular maps at a glance!',
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
                          Container(
                            alignment: Alignment.topLeft,
                            child: const Text(
                              'Ranking Criteria: Number of Likes',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20,),
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
                                return CarouselSlider(
                                  options: CarouselOptions(
                                    height: 400,
                                    enableInfiniteScroll: false,
                                    viewportFraction: 0.8,
                                    enlargeCenterPage: true,
                                    scrollDirection: Axis.horizontal,
                                  ),
                                  items: maps.map((map) {
                                    return Builder(
                                      builder: (BuildContext context) {
                                        return Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50,),
                                          margin: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              print('ListTile clicked');
                                              Get.to(() => MapDetailView(authToken: widget.authToken, map: map, user: widget.user))?.then(
                                                    (result) {
                                                      print('result: $result');
                                                  if (result != null && result is bool) {
                                                    setState(() {
                                                      getMapData();
                                                    });
                                                  }
                                                },
                                              );
                                            },
                                            child: Column(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: GlobalColors.mainColor,
                                                    borderRadius: BorderRadius.circular(90),
                                                  ),
                                                  height: 50,
                                                  width: double.infinity,
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "${maps.indexOf(map) + 1}. ${map.mapName}",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                                ListTile(
                                                  leading: const Icon(Icons.keyboard_arrow_right_outlined),
                                                  title: Text('Level: ${map.level}\n${map.liked} Likes'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }).toList(),
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
      ),
    );
  }

  Future<List<MapRankingData>?> getMapData() async {
    // set cookie
    headers['cookie'] = "x_auth=${widget.authToken}";

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


