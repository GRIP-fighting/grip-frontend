import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:madcamp_week4/screens/login/login.dart';
import 'package:madcamp_week4/widgets/global_button.dart';
import '../../utils/global_colors.dart';
import '../../widgets/global_text_form.dart';

class Signup extends StatelessWidget{
  Signup({Key? key}) : super(key: key);

  final TextEditingController newEmailController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController newNameController = TextEditingController();

  String get emailText => newEmailController.text;
  String get passwordText => newPasswordController.text;
  String get nameText => newNameController.text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: double. infinity,
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Container(
                  alignment: Alignment.center,
                  width: 600,
                  height: 70,
                  child:
                  Image.asset('assets/logo.png', fit: BoxFit.fill,),
                ),
                const SizedBox(height: 30),
                Text(
                  'Create new account',
                  style: TextStyle(
                    color: GlobalColors.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 15),
                // Email input
                GlobalTextForm(
                  controller: newEmailController,
                  text: 'Email',
                  obscure: false,
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10,),
                // Password input
                GlobalTextForm(
                  controller: newPasswordController,
                  text: 'Password',
                  textInputType: TextInputType.text,
                  obscure: false,
                ),
                const SizedBox(height: 10),
                // Name input
                GlobalTextForm(
                  controller: newNameController,
                  text: 'Name',
                  textInputType: TextInputType.text,
                  obscure: false,
                ),
                const SizedBox(height: 10),
                SignupButton(getName: () => nameText, getEmail: () => emailText, getPassword: () => passwordText, role: 0),
                BackToLogin(),
              ]
            ),
          ),
        ),
      ),
    );
  }
}