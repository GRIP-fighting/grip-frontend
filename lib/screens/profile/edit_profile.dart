import 'package:flutter/material.dart';

class EditProfile extends StatelessWidget{
  const EditProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Text(
          'edit profile',
        ),
      ),
    );
  }

}