import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echo/features/auth/models/comment_model.dart';
import 'package:echo/features/posts/widgets/comment_contaienr.dart';
import 'package:flutter/material.dart';

class RepliesListView extends StatelessWidget {
  final String userId;
  const RepliesListView({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
Query query = FirebaseFirestore.instance
        .collectionGroup('comments')
        .where('authorId', isEqualTo: userId)
        .orderBy('createdAt', descending: true);
    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if(snapshot.hasError){
          debugPrint(snapshot.error.toString());
          return Center(
          child: Padding(padding: EdgeInsets.all(16.0),
          child: Text(
                'Something went wrong',
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),),
        );
        }
        if(snapshot.connectionState==ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(),);
        }
        final docs=snapshot.data!.docs;
        if(docs.isEmpty){
          return Center(child: Text('No replies yet!',style: TextStyle(color: Colors.white, fontSize: 16),)
          );
        }
        return ListView.separated(
padding: const EdgeInsets.symmetric(vertical: 10),
          itemBuilder: (context, index) {
            final commentData=docs[index].data() as Map<String,dynamic>;
            final comment=CommentModel.fromMap(commentData);
          return CommentContainer(comment: comment,onReplyTap: () {
            
          },allReplies: [],);
        }, separatorBuilder: (context, index) => Divider(
          color: Colors.white,
          height: 1,
          thickness:0.9 ,
        ), itemCount: docs.length);
      },
    );
  }
}