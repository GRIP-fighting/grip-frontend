import 'package:flutter/material.dart';
import 'package:madcamp_week4/utils/global_colors.dart';

class LoginButton extends StatelessWidget{
  const LoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        print('Login');
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


}

class SignupButton extends StatelessWidget{
  const SignupButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: (){
        print('Sign up');
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