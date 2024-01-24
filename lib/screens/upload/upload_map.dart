import 'package:flutter/material.dart';
import 'package:madcamp_week4/utils/global_colors.dart';

import '../../utils/global_data.dart';

class UploadMap extends StatelessWidget{
  UploadMap({Key? key, required this.authToken, required this.user}) : super(key: key);
  final String authToken;
  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.mainColor,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Share the new map you created!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}