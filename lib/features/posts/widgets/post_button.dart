import 'package:echo/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class PostButton extends StatelessWidget {
  const PostButton({super.key, required this.onTap, required this.isLoading});
final VoidCallback onTap;
final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:isLoading? null:onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: isLoading ? Colors.grey : AppColor.lightBlue,        ),
        child:isLoading?Center(child: CircularProgressIndicator(color: Colors.white,strokeWidth: 2,),) :Text('Post',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),) ,
      ),
    );
  }
}