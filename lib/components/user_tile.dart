import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String text;
  final void Function() onTap;

  const UserTile({
    super.key, 
    required this.text,
    required this.onTap,
  
  });

  

  @override
  
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFE1E1E1),
          borderRadius: BorderRadius.circular(7),


        ),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const Icon(Icons.person),
            
            const SizedBox(width: 20),
            
            //Username
            Text(text),
          ],
        ),
      ),

    );
  }
}