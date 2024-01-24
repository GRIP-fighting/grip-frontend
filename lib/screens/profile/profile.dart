import 'dart:convert';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:madcamp_week4/screens/login/login.dart';
import 'package:madcamp_week4/utils/global_colors.dart';
import 'dart:io';
import 'dart:async';
import '../../utils/global_data.dart';
import 'package:cross_file/cross_file.dart';
import 'package:image/image.dart' as img;
import 'package:http_parser/http_parser.dart';


class ProfileView extends StatefulWidget{
  ProfileView({Key? key, required this.user, required this.authToken}) : super(key: key);
  late final User user;
  final String authToken;
  late List<Solution> solutions;
  late List<LikedMap> likedMaps;
  late List<LikedSolution> likedSolutions;
  late List<MapData> MyMaps;

  late final ImagePicker picker = ImagePicker();
  late XFile? _image = null;

  Uint8List? _imageData;

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  // for auth
  Map<String, String> headers = {};

  // track visibility
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

    return Scaffold(
      appBar: AppBar(
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
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/avatar.jpeg'),
                backgroundColor: Colors.white,
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
            padding: const EdgeInsets.only(top: 30),
            child: Column(
              children: [
                // profile image + navigate to edit page
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
                          ? CircularProgressIndicator()
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
                const SizedBox(height: 10,),
                // navigation buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 5,),
                    // button: show my maps
                    InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        setState(() {
                          toggleContainerVisibility('myMaps');
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
                          'My Maps',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: GlobalColors.mainColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    // button: show my solutions
                    InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        setState(() {
                          toggleContainerVisibility('mySolutions');
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
                          'My Solutions',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: GlobalColors.mainColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    // button: show liked maps
                    InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        setState(() {
                          toggleContainerVisibility('likedMaps');
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
                          'Liked Maps',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: GlobalColors.mainColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    // button: show liked solutions
                    InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        setState(() {
                          toggleContainerVisibility('likedSolutions');
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
                          'Liked Solutions',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: GlobalColors.mainColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5,),
                  ],
                ),

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

  Future<void> logout() async{
    // set cookie
    headers['cookie'] = "x_auth=${widget.authToken}";

    try {
      final response = await http.get(Uri.parse('http://143.248.225.53:8000/api/users/logout'), headers: headers);
      print("Logout Response body: ${response.body}");

      if (response.statusCode == 200) {
        dynamic responseBody = json.decode(response.body);

        if (responseBody is Map && responseBody.containsKey('success')) {
          if(responseBody['success']){
            Get.to(() => LoginView());
          }
        } else {
          print("Logout Error - Unexpected response format");
          return null;
        }
      } else {
        print("Logout Error - Status Code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Logout Error: $e");
      return null;
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
        return null;
      }
    } catch (e) {
      print("Deleting Error: $e");
      return null;
    }
  }

  Future<void> fetchImageData() async {
    // set cookie
    headers['cookie'] = "x_auth=${widget.authToken}";

    try {
      final response = await http.get(Uri.parse('http://143.248.225.53:8000/api/users/profileImage'), headers: headers);
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
        Uri.parse('http://143.248.225.53:8000/api/users/profileImage'),
      );

      // Add the image data as a file part
      request.files.add(http.MultipartFile.fromBytes(
        'profileImage',
        widget._imageData!,
        filename: 'image.jpg',
        contentType: MediaType('image', 'jpeg'),
      ));

      // set cookie
      request.headers['cookie'] = "x_auth=${widget.authToken}";

      // Send the request
      var response = await request.send();

      // Read response
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
}