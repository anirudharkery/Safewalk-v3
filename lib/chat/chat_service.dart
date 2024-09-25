import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:safewalk/models/messages.dart';

class ChatService {

  // Create an instance of Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // User Stream
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection('Users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // Goes through each user and returns to a list
        final user = doc.data();
        return user;

      }).toList();
    });
  }

  //Send Messages  
  Future<void> sendMessage(String receiverId, String message) async {

    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now() ;

    //New Message
    Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      receiverID: receiverId,
      message: message,
      timestamp: timestamp,
    );

    //Constructs unique new chatroom and stores in firebase
    List<String> ids = [currentUserID, receiverId];
    ids.sort();

    String chatRoomID =  ids.join('_');

    await _firestore
      .collection("Chat_rooms")
      .doc(chatRoomID)
      .collection("Messages")
      .add(newMessage.toMap());

    //Get Messages
   
  
  }
  
  Stream<QuerySnapshot> getMessages(String userID, otherUserID){

    //Constructs unique chatroom id
      List<String> ids = [userID, otherUserID];
      ids.sort();
      String chatRoomID = ids.join('_');

      return _firestore.collection("Chat_rooms")
        .doc(chatRoomID)
        .collection("Messages")
        .orderBy('timestamp', descending: false)
        .snapshots();
  }


}