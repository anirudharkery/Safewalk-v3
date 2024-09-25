import 'package:flutter/material.dart';
import 'package:safewalk/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safewalk/components/text_field.dart';

class SignUpView extends StatefulWidget {
  @override
  SignUpViewState createState() => SignUpViewState();
}

class SignUpViewState extends State<SignUpView> {

  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

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
              SizedBox(height: 30),


              //Welcome Message
              Text(
                "Create an Account",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
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
              SizedBox(height: 55),


              //Sign Up Button
              GestureDetector(
                onTap: _signUp,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Center(
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),

              //Already have an account?
              GestureDetector(
                onTap: () {
                  Navigator.pop(context); // Navigate back to the previous page
                },
                child: Text(
                  "Already have an account? Log In",
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


  void _signUp() async {

    //String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User sign up successful. Please verify your email.'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User sign up failed. Please make sure you are using an SCU email.'),
          duration: Duration(seconds: 2),
        ),
      );
    }

  }

}