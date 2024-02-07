import 'dart:convert';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:http_parser/http_parser.dart';

import '../../models/global_data.dart';
import '../../util/global_colors.dart';
import '../login/login.dart';
import '../maps/map_detail.dart';


class ProfileView extends StatefulWidget{
  ProfileView({Key? key, required this.user, required this.authToken}) : super(key: key);
  late final User user;
  final String authToken;
  late List<Solution> solutions;
  late List<LikedMap> likedMaps;
  late List<LikedSolution> likedSolutions;
  late List<MapData> MyMaps;

  late final ImagePicker picker = ImagePicker();
  Uint8List? _imageData;

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  // for auth (cookie)
  Map<String, String> headers = {};

  // type casting
  MapRankingData mapDataToMapRankingData(MapData mapData) {
    return MapRankingData(
      id: mapData.id,
      mapName: mapData.mapName,
      mapPath: mapData.mapPath,
      level: mapData.level,
      liked: mapData.liked,
      likedUserId: [],
      designer: mapData.designer,
      solutionId: mapData.solutionId,
      mapId: mapData.mapId,
    );
  }

  MapRankingData likedMapDataToMapRankingData(LikedMap mapData) {
    return MapRankingData(
      id: mapData.id,
      mapName: mapData.mapName,
      mapPath: mapData.mapPath,
      level: mapData.level,
      liked: mapData.liked,
      likedUserId: [],
      designer: mapData.designer,
      solutionId: mapData.solutionId,
      mapId: mapData.mapId,
    );
  }

  // track visibility: profile screen에서 클릭했을 때 보이는 section 결정
  Map<String, bool> containerVisibility = {
    'myMaps': false,
    'mySolutions': false,
    'likedMaps': false,
    'likedSolutions': false,
  };

  @override
  void initState() {
    super.initState();
    fetchImageData();
  }

  @override
  Widget build(BuildContext context) {
    if(widget._imageData == null){ // image 깜빡거림 해결
      fetchImageData();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: GlobalColors.mainColor,
        elevation: 0,
        foregroundColor: Colors.white.withOpacity(0.4),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: GlobalColors.mainColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              currentAccountPicture: Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: widget._imageData == null
                    ? const CircularProgressIndicator()
                    : ClipOval(
                  child: Image.memory(Uint8List.fromList(widget._imageData as List<int>), fit: BoxFit.fill,),
                ),
              ),
              accountName: Text(
                widget.user.name,
              ),
              accountEmail: Text(
                widget.user.email,
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.logout_outlined,
              color: GlobalColors.textColor,
              ),
              title: Text(
                  'Logout',
                style: TextStyle(
                  color: GlobalColors.textColor,
                  fontSize: 15,
                ),
              ),
              onTap:(){
                logout();
              }
            ),
            ListTile(
                leading: Icon(
                  Icons.delete,
                  color: GlobalColors.textColor,
                ),
                title: Text(
                  'Delete account',
                  style: TextStyle(
                    color: GlobalColors.textColor,
                    fontSize: 15,
                  ),
                ),
                onTap:(){
                  deleteAccount();
                }
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            alignment: Alignment.center,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  height: 400,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: GlobalColors.mainColor,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    // profile image
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: widget._imageData == null
                              ? const CircularProgressIndicator()
                              : ClipOval(
                                  child: Image.memory(Uint8List.fromList(widget._imageData as List<int>), fit: BoxFit.fill,),
                                ),
                        ),
                        InkWell(
                          onTap: (){
                            print('press Edit button');
                            getImage(ImageSource.gallery);
                          },
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.edit,
                              size: 15,
                              color: GlobalColors.mainColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    // name
                    Text(
                      widget.user.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 50,),
                    // score
                    Container(
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
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
                    // email
                    Container(
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10,),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Email',
                            style: TextStyle(
                              color: GlobalColors.textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            widget.user.email,
                            style: TextStyle(
                              color: GlobalColors.textColor,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),
                    // likes
                    Container(
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10,),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Likes',
                            style: TextStyle(
                              color: GlobalColors.textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "${widget.user.liked}",
                            style: TextStyle(
                              color: GlobalColors.textColor,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 70,),
                    // navigation buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 5,),
                        // button: show my maps
                        showProfileInfo('myMap'),
                        // button: show my solutions
                        showProfileInfo('mySolutions'),
                        // button: show liked maps
                        showProfileInfo('likedMaps'),
                        // button: show liked solutions
                        showProfileInfo('likedSolutions'),
                        const SizedBox(width: 10,),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    // visibility for my maps
                    Visibility(
                      visible: containerVisibility['myMaps']!,
                      child: Container(
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
                                  if (snapshot.connectionState == ConnectionState.waiting) { // While data is still loading
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.hasError) { // If there's an error
                                    return Text("Error: ${snapshot.error}");
                                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) { // If data is empty or null
                                    return const Text("No data available.");
                                  } else { // If data is available
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
                                          child: InkWell(
                                            onTap: (){
                                              Get.to(() => MapDetailView(authToken: widget.authToken, map: mapDataToMapRankingData(widget.MyMaps[index]), user: widget.user));
                                            },
                                            child: ListTile(
                                              leading: const Icon(Icons.keyboard_arrow_right_outlined),
                                              title: Text("Map ID: ${widget.MyMaps[index].mapId}"),
                                              subtitle: Text('Level: ${widget.MyMaps[index].level}\n'
                                                  '${widget.MyMaps[index].liked} Likes'),
                                            ),
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
                    ),
                    // visibility for my solutions
                    Visibility(
                      visible: containerVisibility['mySolutions']!,
                      child: Container(
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
                                'My Solutions',
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
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text("Error: ${snapshot.error}");
                                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                    return const Text("No data available.");
                                  } else {
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
                    ),
                    // visibility for liked maps
                    Visibility(
                      visible: containerVisibility['likedMaps']!,
                      child: Container(
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
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text("Error: ${snapshot.error}");
                                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                    return const Text("No data available.");
                                  } else {
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
                                          child: InkWell(
                                            onTap: (){
                                              Get.to(() => MapDetailView(authToken: widget.authToken, map: likedMapDataToMapRankingData(widget.likedMaps[index]), user: widget.user));
                                            },
                                            child: ListTile(
                                              leading: const Icon(Icons.favorite, color: Colors.red,),
                                              title: Text("Map ID: ${widget.likedMaps[index].mapId}"),
                                              subtitle: Text('Designer: ${widget.likedMaps[index].designer}\n'
                                                  '${widget.likedMaps[index].liked} Likes'),
                                            ),
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
                    ),
                    // visibility for liked solutions
                    Visibility(
                      visible: containerVisibility['likedSolutions']!,
                      child: Container(
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
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text("Error: ${snapshot.error}");
                                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                    return const Text("No data available.");
                                  } else {
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
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void toggleContainerVisibility(String containerKey) {
    setState(() {
      // initialize
      containerVisibility['myMaps'] = false;
      containerVisibility['mySolutions'] = false;
      containerVisibility['likedMaps'] = false;
      containerVisibility['likedSolutions'] = false;

      // set visibility
      containerVisibility[containerKey] = !containerVisibility[containerKey]!;
    });
  }

  Future<List<MapData>?> getMyMapData(int id) async {
    String userId = jsonEncode(id);

    // set cookie
    headers['cookie'] = "x_auth=${widget.authToken}";

    try {
      final response = await http.get(Uri.parse('http://13.125.42.66:8000/api/users/$userId'), headers: headers);
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
      final response = await http.get(Uri.parse('http://13.125.42.66:8000/api/users/$userId'), headers: headers);
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
      final response = await http.get(Uri.parse('http://13.125.42.66:8000/api/users/$userId'), headers: headers);
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
      final response = await http.get(Uri.parse('http://13.125.42.66:8000/api/users/$userId'), headers: headers);
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

  Future getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final List<int> imageData = await pickedFile.readAsBytes();

      setState(() {
        widget._imageData = imageData as Uint8List?;
        sendImageData();
      });
    }
  }

  Future<void> fetchImageData() async {
    // set cookie
    headers['cookie'] = "x_auth=${widget.authToken}";

    try {
      final response = await http.get(Uri.parse('http://13.125.42.66:8000/api/users/profileImage/${widget.user.userId}'), headers: headers);
      if (response.statusCode == 200) {
        setState(() {
          widget._imageData = response.bodyBytes;
        });
      } else {
        print('Failed to load image');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> sendImageData() async {
    try {
      var request = http.MultipartRequest(
        'PATCH',
        Uri.parse('http://13.125.42.66:8000/api/users/profileImage'),
      );

      request.files.add(http.MultipartFile.fromBytes(
        'profileImage',
        widget._imageData!,
        filename: 'image.jpg',
        contentType: MediaType('image', 'jpeg'),
      ));

      // set cookie
      request.headers['cookie'] = "x_auth=${widget.authToken}";

      var response = await request.send();
      var responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        print('Successfully uploaded the image');
        return json.decode(responseData.body);
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
    headers['cookie'] = "x_auth=${widget.authToken}";

    try {
      final response = await http.get(Uri.parse('http://13.125.42.66:8000/api/users/logout'), headers: headers);
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
    headers['cookie'] = "x_auth=${widget.authToken}";

    try {
      final response = await http.delete(Uri.parse('http://143.248.225.53:8000/api/users/'), headers: headers);
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

  showProfileInfo(String visibility){
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        setState(() {
          toggleContainerVisibility(visibility);
        });
      },
      child: Container(
        alignment: Alignment.center,
        width: 80,
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: GlobalColors.mainColor,
            width: 2,
          ),
          color: Colors.white,
        ),
        child: Text(
          visibility,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: GlobalColors.mainColor,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}