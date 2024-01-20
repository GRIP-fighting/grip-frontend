import 'dart:convert';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:madcamp_week4/screens/login/login.dart';
import 'package:madcamp_week4/screens/login/signup.dart';
import 'package:madcamp_week4/screens/profile.dart';
import 'package:madcamp_week4/utils/global_colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

// login
class LoginButton extends StatelessWidget{
  const LoginButton({Key? key, required this.getEmail, required this.getPassword, }) : super(key: key);
  final Function() getEmail;
  final Function() getPassword;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        String email = getEmail();
        String password = getPassword();
        bool isSuccess;

        isSuccess = await sendLoginData(email, password);
        if(isSuccess){
          Get.to(() => ProfileView());
        }
        else{
          showToast();
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

  Future<bool> sendLoginData(String email, String password) async{
    dynamic data = {'email': email, 'password': password, };
    String jsonString = jsonEncode(data);
    print('Login Data: $jsonString');
    try {
      final response = await http.post(Uri.parse('http://143.248.225.53:8000/api/users/login'),
          headers: {"Content-Type": "application/json"}, body: jsonString);
      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      // check whether login successed
      if (response.statusCode == 200) {
        dynamic responseBody = jsonDecode(response.body);
        return responseBody['loginSuccess'] ?? false;
      } else {
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
            ),
          ],
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
        child: Text(
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