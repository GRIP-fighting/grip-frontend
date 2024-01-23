import 'package:flutter/material.dart';
import 'package:madcamp_week4/widgets/global_button.dart';

import '../../utils/global_colors.dart';

class RankView extends StatelessWidget{
  const RankView({Key? key, required this.authToken}) : super(key: key);
  final String authToken;

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
          'Ranking',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: SafeArea(
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GoToMapRanking(authToken: authToken),
                const SizedBox(height: 10,),
                GoToUserRanking(authToken: authToken),
              ],
            ),
          ),
        ),
      ),
    );
  }

}