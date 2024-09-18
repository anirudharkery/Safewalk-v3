import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isSender;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isSender,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isSender ? Color(0xFFB23234) : Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      
      child: Text(
        message,
        style: TextStyle(
          color: isSender ? Colors.white : Colors.black,
        ),
      ),
    );
  }


  
}