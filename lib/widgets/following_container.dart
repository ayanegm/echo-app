import 'package:echo/core/theme/app_colors.dart';
import 'package:echo/features/auth/models/user_model.dart';
import 'package:echo/features/profile/profile_cubit.dart';
import 'package:echo/features/profile/profile_state.dart';
import 'package:echo/widgets/follow_button.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FollowingContainer extends StatelessWidget {
  const FollowingContainer({super.key, required this.user});
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        
        bool isCurrentlyFollowing = context.read<ProfileCubit>().isUserFollowing(user.uid); 

        final String myUid = FirebaseAuth.instance.currentUser?.uid ?? '';
        if (user.followers.contains(myUid)) {
          isCurrentlyFollowing = true;
        }

        if (state is FollowStatusChanged && state.userId == user.uid) {
          isCurrentlyFollowing = state.isFollowing;
        }

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
        radius: 20,
        backgroundColor: AppColor.ContainerbackGroundColor,
        child: Text(
          user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
      const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.name, style: const TextStyle(color: AppColor.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Text("@${user.username}", style: const TextStyle(color: AppColor.greyForText)),
                        const SizedBox(height: 2),
                        Text(user.bio ?? '', style: const TextStyle(color: AppColor.white))

                      ],
                    ),
                  ),
                  FollowButton(
                    isFollowing: isCurrentlyFollowing,
                    onTap: () {
                      print(" Button tapped for user: ${user.uid}");
                      context.read<ProfileCubit>().toggleFollow(user.uid);
                    },
                  ),
                ],
              ),
           
        );
      },
    );
  }
}