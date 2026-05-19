import 'package:echo/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  const FollowButton({super.key, required this.onTap,  this.isLoading=false, required this.isFollowing});
final VoidCallback onTap;
final bool isLoading;
final bool isFollowing;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:isLoading? null:onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 19,vertical: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
         color: isLoading 
              ? Colors.grey 
              : (isFollowing ? Colors.transparent : AppColor.white),
          border: isFollowing ? Border.all(color: AppColor.greyForText) : null,
        ),
        child:isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            // 4. تغيير النص واللون بناءً على الـ isFollowing
            : Text(
                isFollowing ? 'Following' : 'Follow',
                style: TextStyle(
                  color: isFollowing ? AppColor.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}