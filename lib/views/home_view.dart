//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:safewalk/components/home/home_nav_bar.dart';
import 'package:safewalk/components/home/home_logo.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD9D9D9),
      bottomNavigationBar: HomeNavBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          HomeLogo(),
          SizedBox(height: 12),
          SizedBox(
            width: 300,
            height: 50,
            
          ),
          // First row with icon and text
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.place, color: Colors.black), // Icon for first sentence
              SizedBox(width: 8), // Horizontal space between icon and text
              Text(
                "Choose a Saved Place",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  letterSpacing: 0.1,
                  fontFamily: "Inter", // Replace with your desired font family
                ),
              ),
            ],
          ),
          SizedBox(height: 16), // Vertical space between rows
          // Second row with icon and text
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.favorite, color: Colors.black), // Icon for second sentence
              SizedBox(width: 8), // Horizontal space between icon and text
              Text(
                "Set destination on map",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  letterSpacing: 0.1,
                  fontFamily: "Inter", // Replace with your desired font family
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
