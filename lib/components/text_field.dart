import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final controller;
  final bool obscureText;


  const MyTextField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.obscureText
  
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary,),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary,),
          ),
          filled: true,
          fillColor: Color(0xFFF5F5F5),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
