import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safewalk/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:safewalk/views/signup_view.dart';
import 'package:safewalk/components/login_button.dart';
import 'package:safewalk/components/text_field.dart';
import 'package:safewalk/views/user-home.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'signup_view.dart';

class LoginView extends StatelessWidget {
  //const LoginView({super.key});
  final FirebaseAuthService _auth = FirebaseAuthService();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  //TextEditingController _usernameController = TextEditingController();
  



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 30),
              //SCU Logo
              Image.asset(
                      "./assets/images/logo_red.png",
                      height: 229,
                      width: 224,
              ),

              SizedBox(height: 10),
              //Welcome Message
              Text(
                "Welcome to SafeWalk",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: "Inter",

                ),
              ),
              SizedBox(height: 30),

              //Email
              MyTextField(
                controller: _emailController,
                hintText: "Email",
                obscureText: false,
              ),
              SizedBox(height:15),   

              //Password
              MyTextField(
                controller: _passwordController,
                hintText: "Password",
                obscureText: true,
                ),
              SizedBox(height: 15),

              //Forgot Password

              Text(
                "Forgot Password?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 15),

              //Login Button
              MyButton(
                onTap: () => _signIn(context),
              ),

              //Sign Up
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    
                    //MaterialPageRoute(builder: (context) => UserHome(title: "Welcome to SafeWalk")),
                    MaterialPageRoute(builder: (context) => SignUpView()),
                  );
                },
                child: Text(
                  "Don't have an account? Sign Up",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }

  void _signIn(BuildContext context) async {
  String email = _emailController.text;
  String password = _passwordController.text;

  User? user = await _auth.signInWithEmailAndPassword(email, password);

  if (user != null) {
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true); 

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserHome(title: "Welcome to SafeWalk",/* onLogout: () {},*/)),
    );
    
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid email or password. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
    print("User sign in failed");
  }
}
}