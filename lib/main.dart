import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:madcamp_week4/screens/maps/rank_main.dart';
import 'package:madcamp_week4/screens/profile/profile.dart';
import 'package:madcamp_week4/screens/splash_view.dart';
import 'package:madcamp_week4/screens/upload/upload_solutions.dart';
import 'package:madcamp_week4/utils/global_colors.dart';
import 'package:madcamp_week4/utils/global_data.dart';

void main() {
  runApp(
     const App(),
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: _buildThemeData(),
      debugShowCheckedModeBanner: false,
      home: const SplashView(),
    );
  }

  ThemeData _buildThemeData() {
    final base = ThemeData(
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.fromSeed(seedColor: GlobalColors.mainColor),
      useMaterial3: true,
      primaryColor: GlobalColors.mainColor,
    );
    return base.copyWith();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.user, required this.authToken,});
  final User user;
  final String authToken;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(),
      ),
      body: Center(
        child: IndexedStack(
          index: _currentIndex,
          children: [
            UploadSolution(),
            RankView(authToken: widget.authToken,),
            ProfileView(user: widget.user, authToken: widget.authToken),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (value) {
          setState((){
            _currentIndex = value;
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: 'upload solution',
            icon: Container(
              padding: const EdgeInsets.all(8.0),
              child: const Icon(Icons.file_upload_outlined),
            ),
            activeIcon: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Icon(Icons.file_upload_outlined),
            ),
          ),
          BottomNavigationBarItem(
            label: 'ranking',
            icon: Container(
              padding: const EdgeInsets.all(8.0),
              child: const Icon(Icons.info_outlined),
            ),
            activeIcon: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Icon(Icons.info_outlined),
            ),
          ),
          BottomNavigationBarItem(
            label: 'profile',
            icon: Container(
              padding: const EdgeInsets.all(8.0),
              child: const Icon(Icons.person_sharp),
            ),
            activeIcon: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Icon(Icons.person_sharp),
            ),
          ),
        ],
      ),
    );
  }
}
