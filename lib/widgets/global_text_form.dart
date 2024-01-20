import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GlobalTextForm extends StatelessWidget{
  const GlobalTextForm({Key? key, required this.controller, required this.text, required this.textInputType, required this.obscure, }) : super(key: key);
  final TextEditingController controller;
  final String text;
  final TextInputType textInputType;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
          ),
        ]
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: textInputType,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: text,
          hintStyle: TextStyle(
            height: 1,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(0),
        ),
      ),
    );
  }
}