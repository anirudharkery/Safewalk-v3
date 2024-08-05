import 'package:flutter/material.dart';
import 'package:safewalk/components/home/cs_nav_bar.dart';

class HomeNavBar extends StatelessWidget {
  const HomeNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.chat, color: Colors.black),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.call, color: Colors.black),
          label: 'Call',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, color: Colors.black),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: CustomCSIcon(),
          label: 'Campus Safety',
        ),
      ],
      type: BottomNavigationBarType.fixed,
      iconSize: 50,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black,
      selectedLabelStyle: TextStyle(color: Colors.black),
      unselectedLabelStyle: TextStyle(color: Colors.black),
    );
  }
}
