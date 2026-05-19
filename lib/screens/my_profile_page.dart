import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echo/core/theme/app_colors.dart';
import 'package:echo/features/auth/cubit/auth_cubit.dart';
import 'package:echo/screens/following_followers_page.dart';
import 'package:echo/widgets/bottom_navigator.dart';
import 'package:echo/widgets/feed_list_view.dart';
import 'package:echo/widgets/following_container.dart';
import 'package:echo/widgets/hover_follow_button.dart';
import 'package:echo/widgets/likes_list_view.dart';
import 'package:echo/widgets/replies_list_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser=context.read<AuthCubit>().currentUser;
    final String userId=currentUser?.uid ??'';
    String name = currentUser?.name ?? 'Name';
  String username = currentUser?.username ?? 'username';
    return DefaultTabController(
      length: 3,
        
        child:  Scaffold(
          
          bottomNavigationBar: CustomBottomNavigatorBar(selectedIndex: 0),
          backgroundColor: Colors.black,
          body: Padding(
            padding: const EdgeInsets.only(left: 15.0,right: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 19,color: Color(0xFFe5e7e8)),),
                Text('@$username',style: TextStyle(color:AppColor.greyForText),),
                SizedBox(height: 5,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.calendar_month_outlined,color: AppColor.greyForText,size: 19,),
                    SizedBox(width: 5,),
                    Text('joined May 2026',style: TextStyle(color:Color(0xFF6d7277) ),),
                  ],
                ),
                Row(children: [
                  SizedBox(width: 3,),
                  HoverFollowButton(
                    count: (currentUser?.followersCount ?? 0).toString(),
                    label: 'followers',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return FollowingFollowersPage(followers:currentUser?.followers ??[], following: currentUser?.following ??[], initialIndex: 0, username: username);
                      },));
                    },
                  ),                  SizedBox(width: 21,),
                  HoverFollowButton(
                    count: (currentUser?.followingCount ?? 0).toString(),

                    label: 'Following',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return FollowingFollowersPage(followers:currentUser?.followers ??[], following: currentUser?.following ??[], initialIndex: 1, username: username);
                      },));
                    },
                  ),
                ],),
                const SizedBox(height: 15), 

                SizedBox(height: 10),
                TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  labelColor: Colors.white,
                  unselectedLabelColor: AppColor.greyForText,
                  indicatorSize: TabBarIndicatorSize.label,
                  dividerColor: Colors.transparent,
                  indicatorColor:AppColor.lightBlue ,
                  tabs: [
                  Tab(text: 'Posts'),
                    Tab(text: 'Replies'),
                    
                    Tab(text: 'Likes'),
                ]),
                Expanded(child: TabBarView(children: [
                      FeedListView(userId: userId,),
                      RepliesListView(userId: userId),
                     
                      LikesListView(userId: userId)
                    ],))
              ],
            ),
          ),
        )
        
        
      
    );
  }
}