import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:madcamp_week4/screens/profile/edit_profile.dart';
import 'package:madcamp_week4/utils/global_colors.dart';
import 'dart:io';
import 'dart:async';

import '../../utils/global_data.dart';

class ProfileView extends StatefulWidget{
  ProfileView({Key? key, required this.user, required this.authToken}) : super(key: key);
  late final User user;
  final String authToken;
  late List<Solution> solutions;
  late List<LikedMap> likedMaps;
  late List<LikedSolution> likedSolutions;
  late List<MapData> MyMaps;

  late XFile? _image = null;
  late final ImagePicker picker = ImagePicker();

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
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
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: widget._image != null
                          ? FileImage(File(widget._image!.path))
                          : const AssetImage('assets/avatar.jpeg') as ImageProvider<Object>,
                    ),
                    InkWell(
                      onTap: (){
                        print('press Edit button');
                        //Get.to(() => EditProfile());
                        getImage(ImageSource.gallery);
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
                  widget.user.name,
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
                        '${widget.user.score}',
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
                // map - my map: maps user made
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
                        const Text(
                          'My Maps',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10,),
                        FutureBuilder<List<MapData>?>(
                          future: getMyMapData(widget.user.userId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              // While data is still loading
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              // If there's an error
                              return Text("Error: ${snapshot.error}");
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              // If data is empty or null
                              return const Text("No data available.");
                            } else {
                              // If data is available
                              widget.MyMaps = snapshot.data!;
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: widget.MyMaps.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: GlobalColors.textColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ListTile(
                                      leading: const Icon(Icons.keyboard_arrow_right_outlined),
                                      title: Text("Map ID: ${widget.MyMaps[index].mapId}"),
                                      subtitle: Text('Level: ${widget.MyMaps[index].level}\n'
                                          '${widget.MyMaps[index].liked} Likes'),
                                    ),
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
                // map - solutions
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
                        const Text(
                            'Solutions',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10,),
                        FutureBuilder<List<Solution>?>(
                          future: getAchievedMapData(widget.user.userId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              // While data is still loading
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              // If there's an error
                              return Text("Error: ${snapshot.error}");
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              // If data is empty or null
                              return const Text("No data available.");
                            } else {
                              // If data is available
                              widget.solutions = snapshot.data!;
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: widget.solutions.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: GlobalColors.textColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ListTile(
                                      leading: const Icon(Icons.keyboard_arrow_right_rounded),
                                      title: Text("Map ID: ${widget.solutions[index].mapId}"),
                                      subtitle: Text('evaluatedLevel: ${widget.solutions[index].evaluatedLevel}'),
                                    ),
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
                // liked maps
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
                        const Text(
                          'Liked Maps',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10,),
                        FutureBuilder<List<LikedMap>?>(
                          future: getLikedMapData(widget.user.userId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              // While data is still loading
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              // If there's an error
                              return Text("Error: ${snapshot.error}");
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              // If data is empty or null
                              return const Text("No data available.");
                            } else {
                              // If data is available
                              widget.likedMaps = snapshot.data!;
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: widget.likedMaps.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: GlobalColors.textColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ListTile(
                                      leading: const Icon(Icons.favorite, color: Colors.red,),
                                      title: Text("Map ID: ${widget.likedMaps[index].mapId}"),
                                      subtitle: Text('Designer: ${widget.likedMaps[index].designer}\n'
                                                      '${widget.likedMaps[index].liked} Likes'),
                                    ),
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
                // liked solutions
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
                        const Text(
                          'Liked Solutions',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10,),
                        FutureBuilder<List<LikedSolution>?>(
                          future: getLikedSolutionData(widget.user.userId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              // While data is still loading
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              // If there's an error
                              return Text("Error: ${snapshot.error}");
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              // If data is empty or null
                              return const Text("No data available.");
                            } else {
                              // If data is available
                              widget.likedSolutions = snapshot.data!;
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: widget.likedSolutions.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: GlobalColors.textColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ListTile(
                                      leading: const Icon(Icons.favorite, color: Colors.red,),
                                      title: Text("Map ID: ${widget.likedSolutions[index].mapId}"),
                                      subtitle: Text('Solution Provider: ${widget.likedSolutions[index].userId}\n'
                                          '${widget.likedSolutions[index].liked} Likes'),
                                    ),
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

  Future<List<MapData>?> getMyMapData(int id) async {
    String userId = jsonEncode(id);

    // set cookie
    headers['cookie'] = "x_auth=${widget.authToken}";

    try {
      final response = await http.get(Uri.parse('http://143.248.225.53:8000/api/users/$userId'), headers: headers);
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
    headers['cookie'] = "x_auth=${widget.authToken}";

    try {
      final response = await http.get(Uri.parse('http://143.248.225.53:8000/api/users/$userId'), headers: headers);
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
    headers['cookie'] = "x_auth=${widget.authToken}";

    try {
      final response = await http.get(Uri.parse('http://143.248.225.53:8000/api/users/$userId'), headers: headers);
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
    headers['cookie'] = "x_auth=${widget.authToken}";

    try {
      final response = await http.get(Uri.parse('http://143.248.225.53:8000/api/users/$userId'), headers: headers);
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

  Future getImage(ImageSource imageSource) async {
    final XFile? pickedFile = await widget.picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        widget._image = XFile(pickedFile.path);
      });
    }
  }
}