import 'package:flutter/material.dart';
//import 'package:safewalk/views/auth/login_view.dart';
import 'package:safewalk/views/auth/login_view.dart';

class Home extends StatelessWidget {
  const Home({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome to SCU-Safewalk.",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: const Color(0xFFFFFFFF),
                  ),
            ),
            Image.asset(
              "./assets/images/logo_white.png",
              height: 200,
              width: 200,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginView(),
                  ),
                );
              },
              child: const Text("Start SafeWalk"),
            ),
          ],
        ),
      ),
    );
  }
}
