import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echo/core/theme/app_colors.dart';
import 'package:echo/features/auth/models/user_model.dart';
import 'package:echo/features/profile/profile_cubit.dart';
import 'package:echo/features/profile/profile_state.dart';
import 'package:echo/widgets/following_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FollowingFollowersPage extends StatelessWidget {
  const FollowingFollowersPage({super.key, required this.followers, required this.following, required this.initialIndex, required this.username});
final List<String>followers;
final List<String>following;
final int initialIndex;
final String username;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: initialIndex, // يفتح على التَبويب الصحيح بناءً على الضغطة المحددة
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            username,
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          bottom: const TabBar(
            indicatorColor: AppColor.lightBlue,
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: Colors.white,
            unselectedLabelColor: AppColor.greyForText,
            tabs: [
              Tab(text: 'Followers'),
              Tab(text: 'Following'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildUsersList(followers, 'No followers yet'),
            _buildUsersList(following, 'Not following anyone yet'),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersList(List<String> ids, String emptyMessage) {
    if (ids.isEmpty) {
      return Center(
        child: Text(emptyMessage, style: const TextStyle(color: AppColor.greyForText, fontSize: 16)),
      );
    }

    final limitedIds = ids.take(30).toList();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where(FieldPath.documentId, whereIn: limitedIds)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: AppColor.lightBlue));
        }

        final docs = snapshot.data!.docs;
if (docs.isEmpty) {
          return Center(
            child: Text(emptyMessage, style: const TextStyle(color: AppColor.greyForText, fontSize: 16)),
          );
        }
        return BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return ListView.separated(
              itemCount: docs.length,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              separatorBuilder: (context, index) => const Divider(color: Colors.white10, height: 1),
              itemBuilder: (context, index) {
                final userData = docs[index].data() as Map<String, dynamic>;
                final user = UserModel.fromMap(userData);

                return FollowingContainer(
                  user: user,
                );
              },
            );
          },
        );
      },
    );
  }
}
