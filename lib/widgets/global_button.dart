import 'dart:convert';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../main.dart';
import '../models/global_data.dart';
import '../screens/login/login.dart';
import '../screens/login/signup.dart';
import '../screens/maps/map_rank.dart';
import '../screens/upload_main.dart';
import '../screens/upload/upload_map.dart';
import '../screens/upload/upload_solution.dart';
import '../screens/users/user_rank.dart';
import '../util/global_colors.dart';

// login
class LoginButton extends StatefulWidget{
  const LoginButton({Key? key, required this.getEmail, required this.getPassword, }) : super(key: key);
  final Function() getEmail;
  final Function() getPassword;

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  String authToken = '';

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () async {
        String email = widget.getEmail();
        String password = widget.getPassword();
        var headers;

        // extract data from response
        http.Response response = await sendLoginData(email, password);
        String tmp = response.body;
        print('response for sendLoginData: $tmp');

        try {
          // get cookie
          if (response.headers != null) {
            headers = response.headers;
            final String? cookies = headers['set-cookie'];
            if (cookies != null && cookies.isNotEmpty) {
              final authTokenCookie = cookies;
              final String tokentmp = authTokenCookie!.split('=')[1];
              final String tokenPart = tokentmp.split(';')[0];
              print('tokenPart: $tokenPart');
              setState(() {
                authToken = tokenPart;
              });
            }
          }

          dynamic jsonData = response.body;
          // get user data
          Map<String, dynamic> jsonMap = json.decode(jsonData);
          UserData userData = UserData.fromJson(jsonMap);

          print('Login Success: ${userData.loginSuccess}');
          print('User ID: ${userData.user.userId}');
          print('User Name: ${userData.user.name}');

          if (userData.loginSuccess) {

            Get.to(() => MyHomePage(user: userData.user, authToken: authToken,));
          } else {
            showToast();
          }
        } catch (e) {
          print("Error parsing response body: $e");
        }
      },
      child: Container(
        alignment: Alignment.center,
        height: 45,
        decoration: BoxDecoration(
          color: GlobalColors.mainColor,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
            ),
          ],
        ),
        child: const Text(
          'Login',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Future<dynamic> sendLoginData(String email, String password) async{
    dynamic data = {'email': email, 'password': password, };
    String jsonString = jsonEncode(data);
    print('Login Data: $jsonString');
    try {
      final response = await http.post(Uri.parse('http://34.201.113.146:8000/api/users/login'),
          headers: {"Content-Type": "application/json"}, body: jsonString);
      print("Response status code: ${response.statusCode}");
      print("Response body for login data: ${response.body}");

      if (response.statusCode == 200) {
        return response;
      } else {
        return '';
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  // show toast when login failed
  void showToast(){
    Fluttertoast.showToast(
      msg: 'login failed',
    );
  }
}
// navigate to signup page
class GoToSignupButton extends StatelessWidget{
  const GoToSignupButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: (){
        Get.to(() => Signup());
      },
      child: Container(
        alignment: Alignment.center,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          'Sign Up',
          style: TextStyle(
            color: GlobalColors.mainColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// register
class SignupButton extends StatelessWidget{
  const SignupButton({Key? key, required this.getName, required this.getEmail, required this.getPassword, required this.role}) : super(key: key);
  final Function() getEmail;
  final Function() getPassword;
  final Function() getName;
  final int role;

  @override
  Widget build(BuildContext context) {
    bool isSuccess;

    return InkWell(
      splashColor: Colors.transparent,
      onTap: () async {
        String name = getName();
        String email = getEmail();
        String password = getPassword();

        isSuccess = await sendSignupData(name, email, password, role);
        if(isSuccess){
          showToast('Signup Successed!');
          Get.to(() => LoginView());
        }
        else{
          // showToast('Signup Failed');
          // exception
          if(password.length < 5){
            showToast('Signup Failed: Password must be longer than 5.');
          }
          else if(!isValidEmail(email)){
            showToast('Signup Failed: Invalid email format.');
          }
        }
      },
      child: Container(
        alignment: Alignment.center,
        height: 45,
        decoration: BoxDecoration(
          color: GlobalColors.mainColor,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
            ),
          ],
        ),
        child: const Text(
          'Sign Up',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Future<bool> sendSignupData(String name, String email, String password, int role,) async{
    dynamic data = {'name': name, 'email': email, 'password': password, 'role': role};
    String jsonString = jsonEncode(data);
    print('signup data: $jsonString');
    try {
      final response = await http.post(Uri.parse('http://143.248.225.53:8000/api/users/register'),
          headers: {"Content-Type": "application/json"}, body: jsonString);
      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      // check whether signup successed
      if (response.statusCode == 200) {
        dynamic responseBody = jsonDecode(response.body);
        return responseBody['success'] ?? false;
      } else {
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  void showToast(String msg){
    Fluttertoast.showToast(
      msg: msg,
    );
  }

  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$',
    );

    return emailRegex.hasMatch(email);
  }

}

class BackToLogin extends StatelessWidget{
  const BackToLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: (){
        Get.to(() => LoginView());
      },
      child: Container(
        alignment: Alignment.center,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          'Back To Login',
          style: TextStyle(
            color: GlobalColors.mainColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

}

class GoToMapRanking extends StatelessWidget{
  const GoToMapRanking({Key? key, required this.authToken, required this.user}) : super(key: key);
  final String authToken;
  final User user;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: (){
        Get.to(() => MapRankView(authToken: authToken, user: user));
      },
      child: Container(
        alignment: Alignment.center,
        width: 200,
        height: 45,
        decoration: BoxDecoration(
          color: GlobalColors.mainColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          'Map Ranking',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class GoToUserRanking extends StatelessWidget{
  const GoToUserRanking({Key? key, required this.authToken}) : super(key: key);
  final String authToken;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: (){
        Get.to(() => UserRankView(authToken: authToken));
      },
      child: Container(
        alignment: Alignment.center,
        width: 200,
        height: 45,
        decoration: BoxDecoration(
          color: GlobalColors.mainColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          'User Ranking',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class GoToMapUpload extends StatelessWidget{
  const GoToMapUpload({Key? key, required this.authToken, required this.user}) : super(key: key);
  final String authToken;
  final User user;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: (){
        Get.to(() => UploadMap(authToken: authToken, user: user));
      },
      child: Container(
        alignment: Alignment.center,
        width: 200,
        height: 45,
        decoration: BoxDecoration(
          color: GlobalColors.mainColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          'Upload Map',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class GoToSolUpload extends StatelessWidget{
  const GoToSolUpload({Key? key, required this.authToken, required this.user}) : super(key: key);
  final String authToken;
  final User user;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: (){
        Get.to(() => UploadSolution(authToken: authToken, user: user));
      },
      child: Container(
        alignment: Alignment.center,
        width: 200,
        height: 45,
        decoration: BoxDecoration(
          color: GlobalColors.mainColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          'Upload Solution',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class UploadMapButton extends StatelessWidget{
  const UploadMapButton({Key? key, required this.authToken, required this.user, required this.getName, required this.getPath, required this.getLevel}) : super(key: key);
  final String authToken;
  final User user;
  final Function() getName;
  final Function() getPath;
  final Function() getLevel;

  @override
  Widget build(BuildContext context) {
    bool isSuccess;

    return InkWell(
      splashColor: Colors.transparent,
      onTap: () async {
        String name = getName();
        String path = getPath();
        String level = getLevel();

        isSuccess = await sendMapData(name, path, int.parse(level), user.userId);
        if(isSuccess){
          showToast('Upload Successed!');
          Get.to(() => UploadMain(authToken: authToken, user: user,));
        }
        else{
          showToast('Upload Failed');
        }
      },
      child: Container(
        alignment: Alignment.center,
        height: 45,
        decoration: BoxDecoration(
          color: GlobalColors.mainColor,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
            ),
          ],
        ),
        child: const Text(
          'Upload',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Future<bool> sendMapData(String name, String path, int level, int designerId) async{
    dynamic data = {'mapName': name, 'mapPath': path, 'level': level, 'designer': designerId};
    String jsonString = jsonEncode(data);
    print('sendMap data: $jsonString');

    try {
      final response = await http.post(Uri.parse('http://143.248.225.53:8000/api/maps'),
          headers: {"Content-Type": "application/json"}, body: jsonString);
      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      // check whether upload success
      if (response.statusCode == 200) {
        dynamic responseBody = jsonDecode(response.body);
        return responseBody['success'] ?? false;
      } else {
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  void showToast(String msg){
    Fluttertoast.showToast(
      msg: msg,
    );
  }
}

class UploadSolButton extends StatelessWidget{
  const UploadSolButton({Key? key, required this.authToken, required this.user, required this.getId, required this.getPath, }) : super(key: key);
  final String authToken;
  final User user;
  final Function() getId;
  final Function() getPath;

  @override
  Widget build(BuildContext context) {
    bool isSuccess;

    return InkWell(
      splashColor: Colors.transparent,
      onTap: () async {
        String id = getId();
        String path = getPath();

        isSuccess = await sendSolData(int.parse(id), path);
        if(isSuccess){
          showToast('Upload Successed!');
          Get.to(() => UploadMain(authToken: authToken, user: user,));
        }
        else{
          showToast('Upload Failed');
        }
      },
      child: Container(
        alignment: Alignment.center,
        height: 45,
        decoration: BoxDecoration(
          color: GlobalColors.mainColor,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
            ),
          ],
        ),
        child: const Text(
          'Upload',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Future<bool> sendSolData(int id, String path) async{
    dynamic data = {'mapId': id, 'mapPath': path};
    String jsonString = jsonEncode(data);
    print('sendSolData data: $jsonString');

    try {
      final response = await http.post(Uri.parse('http://143.248.225.53:8000/api/maps'),
          headers: {"Content-Type": "application/json"}, body: jsonString);
      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      // check whether upload success
      if (response.statusCode == 200) {
        dynamic responseBody = jsonDecode(response.body);
        return responseBody['success'] ?? false;
      } else {
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  void showToast(String msg){
    Fluttertoast.showToast(
      msg: msg,
    );
  }
}

