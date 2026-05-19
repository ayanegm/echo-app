import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echo/features/auth/models/tweets_model.dart';
import 'package:echo/widgets/tweets_container.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class FeedListView extends StatelessWidget {
  const FeedListView({super.key,this.userId});
final String? userId;
  @override
  Widget build(BuildContext context) {
    Query query=FirebaseFirestore.instance.collection('tweets');
    if(userId !=null){
      query=query.where('authorId',isEqualTo: userId);
    }
    query=query.orderBy('createdAt',descending:true);
    return Container(
    decoration: const BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
      border: Border(
        top: BorderSide(color: Colors.white10, width: 0.9),
        left: BorderSide(color: Colors.white10, width: 0.9),
        right: BorderSide(color: Colors.white10, width: 0.9),
      ),
    ),
    child: ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
      child: StreamBuilder(
        builder: (context, snapshot) {
          if(snapshot.hasError){
            print(snapshot.error);
            return Center(child:Text('Error: ${snapshot.error}',style: TextStyle(color: Colors.white),) ,);
          }
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
          final docs=snapshot.data!.docs;
          if(docs.isEmpty){
            return Center(child: Text('No posts  yet!',style: TextStyle(color: Colors.white),),);
          }
         return ListView.separated(
          itemCount: docs.length,
          padding: const EdgeInsets.only(bottom: 0), 
          itemBuilder: (context, index) {
            final tweetData=docs[index].data() as Map<String,dynamic>;
            final tweet=TweetsModel.fromMap(tweetData);
            return TweetsContainer(tweetsModel: tweet,);
          } ,
          
          separatorBuilder: (context, index) => const Divider(
            color: Colors.white10,
            height: 1,
            thickness: 0.9,
            indent: 0,
            endIndent: 0,
          ),
        );
        },
        stream:query.snapshots(), 
      
    ),
  ));
  }
}