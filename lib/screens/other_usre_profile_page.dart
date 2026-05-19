import 'package:echo/core/theme/app_colors.dart';
import 'package:echo/features/auth/models/user_model.dart';
import 'package:echo/screens/following_followers_page.dart';
import 'package:echo/widgets/bottom_navigator.dart';
import 'package:echo/widgets/feed_list_view.dart';
import 'package:echo/widgets/following_container.dart';
import 'package:echo/widgets/hover_follow_button.dart';
import 'package:echo/widgets/likes_list_view.dart';
import 'package:echo/widgets/replies_list_view.dart';
import 'package:flutter/material.dart';

class OtherUsreProfilePage extends StatelessWidget {
  const OtherUsreProfilePage({super.key, required this.user, required this.index});
final UserModel user;
final int index;
  @override
  Widget build(BuildContext context) {
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
               FollowingContainer(user: user),
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
                    count: user.followersCount.toString(),
                    label: 'followers',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return FollowingFollowersPage(followers:user?.followers ??[], following: user?.following ??[], initialIndex: 0, username: user.username);
                      },));
                    },
                  ),                  SizedBox(width: 21,),
                  HoverFollowButton(
                    count: user.followingCount.toString(),
                    label: 'Following',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return FollowingFollowersPage(followers:user?.followers ??[], following: user?.following ??[], initialIndex: 1, username: user.username);
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
                      FeedListView(userId: user.uid,),
                      RepliesListView(userId: user.uid),
                      LikesListView(userId: user.uid)
                    ],))
              ],
            ),
          ),
        )
        
        
      
    );
  }
}