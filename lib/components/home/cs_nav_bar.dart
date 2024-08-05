import 'package:flutter/material.dart';

class CustomCSIcon extends StatelessWidget {
  const CustomCSIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.0, // Specify width as double (non-const value)
      height: 50.0, // Specify height as double (non-const value)
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
      ),
      child: Center(
        child: Text(
          'CS',
          style: TextStyle(
            fontFamily: 'Inter',
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 24.0, // Specify fontSize as double (non-const value)
          ),
        ),
      ),
    );
  }
}
