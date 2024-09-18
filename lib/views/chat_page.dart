
import 'package:flutter/material.dart';
import 'package:safewalk/components/chat_bubble.dart';
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
    String username = receiverEmail.split('@')[0];
    return Scaffold(
      appBar: AppBar(
        title: Text(username),
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
          ChatBubble(
            message: data['message'],
            isSender: isCurrentUser,
          ),
        ],
      ),
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, 
        children: [
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 350), 
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFE5E5E5), 
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message",
                      border: InputBorder.none, // Removes the default underline
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10.0), // Adds spacing between input and send button
            decoration: BoxDecoration(
              color: Color(0xFFB23234), 
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_upward_rounded, color: Colors.white), 
              onPressed: sendMessage,
            ),
          ),
        ],
      ),
    );
  }

}