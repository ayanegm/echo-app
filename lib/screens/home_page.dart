import 'package:echo/core/theme/app_colors.dart';
import 'package:echo/widgets/bottom_navigator.dart';
import 'package:echo/widgets/feed_list_view.dart';
import 'package:echo/widgets/tweets_container.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: CustomBottomNavigatorBar(selectedIndex: 0),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Center(child: Text('Home',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),)),
            SizedBox(height: 20),
            Expanded(
          child: FeedListView()
        )
        ],),
      ),
    );
  }
}