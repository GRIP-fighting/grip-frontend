import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:madcamp_week4/provider/auth_provider.dart';
import 'package:madcamp_week4/screens/splash_view.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
     const App(),
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashView(),
    );
  }
}
