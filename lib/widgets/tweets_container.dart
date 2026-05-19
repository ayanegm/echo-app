import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echo/core/theme/app_colors.dart';
import 'package:echo/features/auth/cubit/auth_cubit.dart';
import 'package:echo/features/auth/models/comment_model.dart';
import 'package:echo/features/auth/models/tweets_model.dart';
import 'package:echo/features/posts/cubit/post_cubit.dart';
import 'package:echo/features/posts/widgets/comment_contaienr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TweetsContainer extends StatelessWidget {
  const TweetsContainer({super.key, required this.tweetsModel,});
final TweetsModel tweetsModel;

  @override
  Widget build(BuildContext context) {
    void _showCommentSheet(BuildContext context){
      final TextEditingController commentController=TextEditingController();
     String?selectedParentId;
      showModalBottomSheet(context: context, isScrollControlled: true,backgroundColor: Color(0xFF141414),shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.vertical(top: Radius.circular(20))),
      builder:  (context) {
        return StatefulBuilder(
builder: (BuildContext context, StateSetter setSheetState) {
            return Padding(padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right:20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Comments',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
              Divider(color: Colors.white10,),
              SizedBox(
                height: 300,
                child: StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance.collection('tweets').doc(tweetsModel.tweetId).collection('comments').orderBy('createdAt',descending: true).snapshots(),
                 builder: (context, snapshot) {
                   if(!snapshot.hasData){
                    return Center(child: CircularProgressIndicator(),);
                   }
                   final allDocs=snapshot.data!.docs;
                   List<CommentModel>allComments=allDocs.map((doc)=>CommentModel.fromMap(doc.data() as Map<String,dynamic>)).toList();
                   List<CommentModel>finalDisplayList=[];
                   var mainComments=allComments.where((c)=>c.parentCommentId==null).toList();
                  for(var main in mainComments){
                    finalDisplayList.add(main);
                    var replies=allComments.where((c)=>c.parentCommentId==main.commentId).toList();
                    replies.sort((a,b)=>a.createdAt.compareTo(b.createdAt));
                    finalDisplayList.addAll(replies);
                  }
                   return ListView.separated(
                    itemCount: mainComments.length,
                    separatorBuilder: (context, index) => const Divider(color: Colors.white10, height: 1),
                    itemBuilder: (context, index) {
                    final comment = mainComments[index];
                    List<CommentModel> currentReplies=allComments.where((c)=>c.parentCommentId==comment.commentId).toList();
                    currentReplies.sort((a,b)=>a.createdAt.compareTo(b.createdAt));
                     return CommentContainer(comment: comment,onReplyTap: () {
                       setSheetState((){
                        selectedParentId=comment.commentId;
                       });
                       print("replying to ${comment.commentId}");
                     }, allReplies: currentReplies,);
                       
                   },);
                 },),
              ),
              TextField(
                controller: commentController,
                style:const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText:selectedParentId==null? "Write a comment...":'Replying to reply...',

                  hintStyle:  TextStyle(color: selectedParentId==null?Colors.grey:Colors.blue),
                  prefixIcon: selectedParentId !=null?IconButton(onPressed: () { setSheetState((){
                    selectedParentId=null;
                  });}, icon: Icon(Icons.close,color: Colors.white,)):null,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send, color: Colors.blue),
                    onPressed: () {
                      final user=context.read<AuthCubit>().currentUser;
                      if(user!=null&&commentController.text.isNotEmpty){
                        context.read<PostCubit>().addComment(authorId: user.uid, parentCommentId: selectedParentId,postId: tweetsModel.tweetId, text: commentController.text);
                        commentController.clear();
                        setSheetState(()=>selectedParentId==null);
                      }
                    },
              ),
          ),
              )
          ]));
      });
      },);
    }
    return Container(
  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 12),
    
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder(
            future: FirebaseFirestore.instance.collection('users').doc(tweetsModel.authorId).get(),
            builder: (context, snapshot) {
              String name='Loading...';
              if(snapshot.hasData && snapshot.data!.exists){
                name=snapshot.data!['name'];
              }
              return Row(
               
                children: [
                  Text(
                    name
                    ,style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: AppColor.white
                    ),
                  ),
                  SizedBox(width: 6,),
                  Text(
                    "${tweetsModel.createdAt.hour}:${tweetsModel.createdAt.minute}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.grey
                    ),
                    
                  ),
                ],
              );
            }
          ),
          SizedBox(height: 8,),

          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8, 
            child: Text(
              tweetsModel.text,
              style: TextStyle(
                color: AppColor.white,
                fontSize: 14,
                height: 1.4,  
              ),
              softWrap: true, 
              overflow: TextOverflow.visible,
            ),
          ),
          Row(
            
            children: [
              IconButton(onPressed: () {
                final currentUser=context.read<AuthCubit>().currentUser;
                if(currentUser!=null){
                  context.read<PostCubit>().toggleLike(tweetId:tweetsModel.tweetId , userId: currentUser.uid);
                }
              }, icon:Icon(tweetsModel.likes.contains(context.read<AuthCubit>().currentUser?.uid)? Icons.favorite: Icons.favorite_border,color:tweetsModel.likes.contains(context.read<AuthCubit>().currentUser?.uid)? Colors.red: AppColor.white,)),
              Text('${tweetsModel.likeCount}',style: TextStyle(color: Colors.white,fontSize: 12),)
              ,IconButton(onPressed: () =>_showCommentSheet(context), icon:Icon( Icons.chat_bubble_outline,color: AppColor.white,)),
              Text('${tweetsModel.commentCount}',style: TextStyle(color: Colors.white,fontSize: 12),)
            ],
          )
        ],
      ),
    );
  }
}