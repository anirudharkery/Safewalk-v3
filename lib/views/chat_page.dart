
import 'package:flutter/material.dart';
import 'package:safewalk/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:safewalk/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class ChatPage extends StatelessWidget {
  //final String receiverName;
  final String receiverId;
  final String receiverEmail;
  //final String receiverProfilePic;


  ChatPage({
    super.key, 
    required this.receiverId,
    required this.receiverEmail

  });

  final TextEditingController _messageController = TextEditingController();

  final ChatService _chatService = ChatService();
  final FirebaseAuthService _authService = FirebaseAuthService();

  void sendMessage() async{
    if(_messageController.text.isNotEmpty){
      //Send message and clear text field
      await _chatService.sendMessage(receiverId, _messageController.text);  
      _messageController.clear();
    }
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(receiverId),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList(){
    String senderID = _authService.getCurrentUser()!.uid;

    return StreamBuilder(
      stream: _chatService.getMessages(receiverId, senderID),
      builder: (context, snapshot){
        if(snapshot.hasError){
          return const Text("Error");
        }

        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView(
          children: 
            snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),

        );

      }
    );

  }

  Widget _buildMessageItem(DocumentSnapshot doc){
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    //Current user message
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;

    var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(data['message']),
        ],
      ),
    );
  }

  Widget _buildUserInput(){
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            decoration: InputDecoration(
              hintText: "Type a message",
            ),
          ),
        ),

        IconButton(
          icon: Icon(Icons.send),
          onPressed: sendMessage,
        ),

      ],
    );
  }

}