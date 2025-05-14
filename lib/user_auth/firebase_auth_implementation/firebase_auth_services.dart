import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';




class FirebaseAuthService{
  //Instance of firebase auth and firestore
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Current User
  User? getCurrentUser(){
    return _auth.currentUser;
  }

  Future<User?> signUpWithEmailAndPassword(String email, String password) async{

    try {

      //Creates User
      if (email.endsWith('@scu.edu')){
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, 
          password: password
        );
        
        //Store user data in firestore
        _firestore.collection('Users').doc(credential.user!.uid).set({
          'email': email,
          'username': email.split('@')[0],
          'uid': credential.user!.uid,
          'role': 'walkee',
        });

        User? user = credential.user;

        if(user != null){
          user.sendEmailVerification();
          return user;
        }
      }else{
        print("Please an SCU email to sign up");
      }
      
    }catch(e){
      print("Some error occured");
    }

    return null;

  }


  Future<User?> signInWithEmailAndPassword(String email, String password) async{

    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );

      _firestore.collection('Users').doc(credential.user!.uid).set({
          'email': email,
          'username': email.split('@')[0],
          'uid': credential.user!.uid,
        });

      return credential.user;

    } catch(e){
      print("Some error occured");
    }

    return null;

  }


}