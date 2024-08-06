import 'package:flutter/material.dart';

class HomeLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 490,
      height: 190,
      color: Colors.white,
      
      child: Column(
        children: [
          SizedBox(height: 50),
          Image.asset(
            "./assets/images/logo_white.png",
            height: 129,
            width: 124,
          ),
        ]
      ),
    );
  }
}
