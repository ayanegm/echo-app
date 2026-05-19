import 'package:echo/features/auth/widgets/auth_button.dart';
import 'package:echo/widgets/feed_list_view.dart';
import 'package:echo/widgets/tweets_container.dart';
import 'package:flutter/material.dart';

class ProfileSetupPage extends StatelessWidget {
  const ProfileSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0,vertical: 20),
        child: Column(
          children: [
            Text('Mo Salah',style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontSize: 17),),
            SizedBox(height: 20,),
            AuthButton(text: 'Follow', onTap: () {
              
            },),
            SizedBox(height: 20,),
            Expanded(
              child: DefaultTabController(length: 2, child: Column(
                children: [
                  TabBar(
                    labelColor: Colors.white,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14
                    ),
                    unselectedLabelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14
                    ),
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.white,
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: [
                    Tab(text: 'Tweets',),
                    Tab(text: 'Replies',),
                  ]),
                  Expanded(child: TabBarView(children: [
                    FeedListView(),
                    Center(child: Text('data'),),
                  ]))
                ],
              )),
            )
          ],
        ),
      ),
    );
  }
}