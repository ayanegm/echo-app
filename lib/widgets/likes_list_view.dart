import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echo/features/auth/models/tweets_model.dart';
import 'package:echo/features/auth/models/user_model.dart';
import 'package:echo/widgets/tweets_container.dart';
import 'package:flutter/material.dart';

class LikesListView extends StatelessWidget {
  const LikesListView({super.key, required this.userId});
  final String userId;
  @override
  Widget build(BuildContext context) {
    Query query =FirebaseFirestore.instance.collection('tweets').where('likes',arrayContains: userId).orderBy('createdAt',descending: true);

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if(snapshot.hasError){
          debugPrint(snapshot.error.toString());
          return Center(child: Text('Something went wrong',style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ));
        }
       if(snapshot.connectionState==ConnectionState.waiting){
        return Center(child: CircularProgressIndicator(),);
       }
       final docs=snapshot.data!.docs;
       if(docs.isEmpty){
        return Center(child: Text('No liked posts yet!',style: TextStyle(color: Colors.white, fontSize: 16),));
       }
       return ListView.separated(itemBuilder: (context, index) {
        final tweetData=docs[index].data() as Map<String,dynamic>;
         final tweet=TweetsModel.fromMap(tweetData);
         return TweetsContainer(tweetsModel: tweet);

       }, separatorBuilder: (context,index)=>Divider(
        color: Colors.white,
        height: 1,
        thickness: 0.9,
       ), itemCount: docs.length);
      },
    );
  }
}