import 'package:flutter/material.dart';
import 'package:madcamp_week4/utils/global_colors.dart';
import 'package:madcamp_week4/widgets/global_button.dart';
import 'package:madcamp_week4/widgets/global_text_form.dart';


class LoginView extends StatelessWidget{
  LoginView({Key? key}) : super(key: key);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String get emailText => emailController.text;
  String get passwordText => passwordController.text;

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
                    'Login to your account',
                  style: TextStyle(
                    color: GlobalColors.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 15),
                // Email input
                GlobalTextForm(
                    controller: emailController,
                    text: 'Email',
                    obscure: false,
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10,),
                // Password input
                GlobalTextForm(
                    controller: passwordController,
                    text: 'Password',
                    textInputType: TextInputType.text,
                    obscure: true,
                ),
                const SizedBox(height: 10,),
                LoginButton(getEmail: () => emailText, getPassword: () => passwordText),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Don\'t have an account?',
                      style: TextStyle(
                        color: GlobalColors.textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    GoToSignupButton(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}