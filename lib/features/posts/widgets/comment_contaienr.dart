import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echo/core/theme/app_colors.dart';
import 'package:echo/features/auth/cubit/auth_cubit.dart';
import 'package:echo/features/auth/models/comment_model.dart';
import 'package:echo/features/posts/cubit/post_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentContainer extends StatefulWidget {
  final CommentModel comment;
  final VoidCallback onReplyTap;
  final List<CommentModel>allReplies;
  const CommentContainer({super.key, required this.comment, required this.onReplyTap, required this.allReplies});

  @override
  State<CommentContainer> createState() => _CommentContainerState();
}

class _CommentContainerState extends State<CommentContainer> {
  bool showReplies=false;
  @override
  Widget _buildMainComment(){
    double leftPadding = widget.comment.parentCommentId == null ? 0 : 40;
    return Padding(
         padding: EdgeInsets.only(left: leftPadding),
         child: Container(
           padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 12),
          
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              
                 FutureBuilder<DocumentSnapshot>(
                  builder: (context, snapshot) {
                    String name="...";
                    if(snapshot.hasData && snapshot.data!.exists){
                      name=snapshot.data!['name'];
                    }
                    return  Row(
                       crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                             CircleAvatar(
                radius: 16, 
                backgroundColor:AppColor.ContainerbackGroundColor ,
                child: Text(
                  name.isNotEmpty && name != 'Loading...'
                      ? name[0].toUpperCase()
                      : 'U',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 8,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${name}'
                                  ,style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: AppColor.white
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 6,),
                          Text(
         "${widget.comment.createdAt.hour}:${widget.comment.createdAt.minute.toString().padLeft(2, '0')}",                      style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.grey
                            ),
                            
                          ),
                        ],
                   );
                  },
                  future:FirebaseFirestore.instance.collection('users').doc(widget.comment.authorId).get() ,
                   
                 ),
                SizedBox(height: 8,),
         
                Padding(
padding: const EdgeInsets.only(left: 7.0, top: 4, bottom: 4),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8, 
                    child: Text(
                      '${widget.comment.text}',
                      style: TextStyle(
                        color: AppColor.white,
                        fontSize: 14,
                        height: 1.4,  
                      ),
                      softWrap: true, 
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ),
                Row(
                  
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
constraints: const BoxConstraints(),
visualDensity: VisualDensity.compact,onPressed: () {
                      context.read<PostCubit>().toggleLike(tweetId: widget.comment.postId, userId:context.read<AuthCubit>().currentUser!.uid,commentId: widget.comment.commentId );
                    }, icon:Icon(widget.comment.likes.contains(context.read<AuthCubit>().currentUser?.uid)? Icons.favorite: Icons.favorite_border,color:widget.comment.likes.contains(context.read<AuthCubit>().currentUser?.uid)? Colors.red: AppColor.white,)),
                    Text('${widget.comment.likeCount}',style: TextStyle(fontSize: 12,color: Colors.white,),)
                    ,IconButton(onPressed:widget.onReplyTap, icon:Icon( Icons.chat_bubble_outline,color: AppColor.white,)),
                  ],
                )
              ],
            ),
          ),
       );
  }
  Widget build(BuildContext context) {
   return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      _buildMainComment(),
      if (widget.allReplies.isNotEmpty && !showReplies)
          Padding(
            padding: const EdgeInsets.only(left: 60, bottom: 10),
            child: InkWell(
              onTap: () => setState(() => showReplies = true),
              child: Text(
                "View ${widget.allReplies.length} replies",
                style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ),
          ),
      if(showReplies)
      Column(
            children: widget.allReplies.map((reply) {
              return CommentContainer(
                comment: reply,
                onReplyTap: widget.onReplyTap,
                allReplies: [], 
              );
            }).toList(),
          ),
          if(showReplies && widget.allReplies.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 60, bottom: 10),
            child: InkWell(
              onTap: () => setState(() => showReplies = false),
              child: const Text("Hide replies", style: TextStyle(color: Colors.grey)),
            ),
          ),
     ],
   );
  }
}