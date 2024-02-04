import 'package:flutter/material.dart';

import '../../models/global_data.dart';
import '../../util/global_colors.dart';
import '../../widgets/global_button.dart';
import '../../widgets/global_text_form.dart';

class UploadSolution extends StatelessWidget{
  UploadSolution({Key? key, required this.authToken, required this.user}) : super(key: key);
  final String authToken;
  final User user;

  // input controllers
  final TextEditingController idController = TextEditingController();
  final TextEditingController pathController = TextEditingController();

  String get idText => idController.text;
  String get pathText => pathController.text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.mainColor,
      body: Center(
        child: SafeArea(
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Share the new solution you created!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    shadows: [
                      Shadow(
                        blurRadius: 8,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20,),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: GlobalColors.textColor.withOpacity(0.3),
                      ),
                    ),
                    Container(
                      width: 270,
                      height: 270,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      height: 250,
                      child: IconButton(
                        onPressed: () {
                          solutionUploadDialog(context);
                        },
                        icon: Icon(
                          Icons.add_outlined,
                          color: GlobalColors.mainColor.withOpacity(0.8),
                          size: 150,
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

  void solutionUploadDialog(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 800,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: GlobalColors.textColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      height: 5,
                      width: 100,
                    ),
                    const SizedBox(height: 20,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fill out the fields.',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: GlobalColors.textColor,
                          ),
                        ),
                        const SizedBox(height: 10,),
                        // map id
                        Text(
                          'Map id',
                          style: TextStyle(
                            color: GlobalColors.textColor,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10,),
                        GlobalTextForm(controller: idController, text: '', textInputType: TextInputType.text, obscure: false),
                        const SizedBox(height: 10,),
                        // solution path
                        Text(
                          'Solution path',
                          style: TextStyle(
                            color: GlobalColors.textColor,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10,),
                        GlobalTextForm(controller: pathController, text: '', textInputType: TextInputType.text, obscure: false),
                        const SizedBox(height: 10,),
                        UploadSolButton(authToken: authToken, user: user, getId: () => idText, getPath: () => pathText),
                        const SizedBox(height: 5,),
                      ],
                    ),
                  ],
                ),
              )
          ),
        );
      },
    );
  }
}