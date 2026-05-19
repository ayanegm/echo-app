import 'package:flutter/material.dart';

class PostTextField extends StatelessWidget {
  const PostTextField({super.key, required this.controller});
final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      
      child: Padding(
        padding: const EdgeInsets.only(top: 2.0),
        child: Center(
          child: TextField(
            controller: controller,
            autofocus: true,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white,fontSize: 19),
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
              
              hintText: 'What\'s happening?',
             
              hintStyle: TextStyle(color: const Color(0xFF676c70,),fontSize: 19),
              border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
            ),
          ),
        ),
      ),
    );
  }
}