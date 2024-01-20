import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:madcamp_week4/screens/login.dart';
import 'package:madcamp_week4/utils/global_colors.dart';

class SplashView extends StatelessWidget{
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 2), (){
      Get.to(LoginView());
    });
    return Scaffold(
      backgroundColor: GlobalColors.mainColor,
      body: Center(
        child: Image.asset(
          width: 200,
          height: 200,
          'assets/logo_main.png',
        ),
      ),
    );
  }
}