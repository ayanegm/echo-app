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
      // 🔥 شيلنا الـ buildWhen تماماً عشان الـ Bloc Builder ما يعلقش الضغطات
      builder: (context, state) {
        
        // 1. الحالة الافتراضية من الـ Cubit
        bool isCurrentlyFollowing = context.read<ProfileCubit>().isUserFollowing(user.uid); 

        // 2. التحقق من الـ Followers في الفايربيز
        final String myUid = FirebaseAuth.instance.currentUser?.uid ?? '';
        if (user.followers.contains(myUid)) {
          isCurrentlyFollowing = true;
        }

        // 3. لو الـ State اتغيرت حالا بسبب الضغط، بنجبره ياخد الحالة الجديدة فوراً
        if (state is FollowStatusChanged && state.userId == user.uid) {
          isCurrentlyFollowing = state.isFollowing;
        }

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name, style: const TextStyle(color: AppColor.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      Text("@${user.username}", style: const TextStyle(color: AppColor.greyForText)),
                    ],
                  ),
                  FollowButton(
                    isFollowing: isCurrentlyFollowing,
                    onTap: () {
                      print("🎯 Button tapped for user: ${user.uid}");
                      context.read<ProfileCubit>().toggleFollow(user.uid);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Text(user.bio ?? '', style: const TextStyle(color: AppColor.white))
            ],
          ),
        );
      },
    );
  }
}