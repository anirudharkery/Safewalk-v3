import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      if (email.endsWith('@scu.edu')) {
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        User? user = credential.user;
        if (user != null) {
          // TODO: Navigate to a success screen and Show Success Message
          user.sendEmailVerification();
          return user;
        }
      } else {
        // TODO: Show Error Message to user
        print("Please an SCU email to sign up");
      }
    } catch (e) {
      // TODO: Show Error Message to user
      print("Some error occured");
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      // TODO: Show Error Message to user
      print("Some error occured");
    }
    return null;
  }
}
