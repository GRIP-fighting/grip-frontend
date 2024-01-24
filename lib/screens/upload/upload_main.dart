import 'package:flutter/material.dart';
import '../../utils/global_colors.dart';
import '../../utils/global_data.dart';
import '../../widgets/global_button.dart';

class UploadMain extends StatelessWidget{
  UploadMain({Key? key, required this.authToken, required this.user}) : super(key: key);
  final String authToken;
  final User user;

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
          'Upload',
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
                Image.asset(
                  width: 100,
                  height: 100,
                  'assets/logo.png',
                  fit: BoxFit.contain,
                ),
                GoToMapUpload(authToken: authToken, user: user),
                const SizedBox(height: 10,),
                GoToSolUpload(authToken: authToken, user: user),
              ],
            ),
          ),
        ),
      ),
    );
  }

}