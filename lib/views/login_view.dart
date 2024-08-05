import 'package:flutter/material.dart';
import 'signup_view.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to the Login Page!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16,),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                //  Implement login logic
              },
              child: Text('Login'),
            ),
            SizedBox(height: 16),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpView()),
                  );
                },
                child: Text(
                  'Don\'t have an account?',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                    decoration: TextDecoration.underline,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}