import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echo/features/auth/models/comment_model.dart';
import 'package:echo/features/auth/models/tweets_model.dart';
import 'package:echo/features/auth/models/user_model.dart';
import 'package:echo/features/posts/cubit/post_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostCubit extends Cubit<PostState>{
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;

PostCubit() : super(PostInitial());
  Future<void>toggleLike({required String tweetId,required userId,String? commentId})async{
    try{
      DocumentReference docRef;
      if(commentId !=null){
        docRef=_firestore.collection('tweets').doc(tweetId).collection('comments').doc(commentId);
      }
      else{
        docRef=_firestore.collection('tweets').doc(tweetId);
      }
      DocumentSnapshot doc=await docRef.get();
      List likes=doc['likes']??[];
      if(likes.contains(userId)){
        await docRef.update({
          'likes':FieldValue.arrayRemove([userId]),
        'likeCount':FieldValue.increment(-1)
        });
      }
      else{
        await docRef.update({
          'likes':FieldValue.arrayUnion([userId]),
          'likeCount':FieldValue.increment(1)
        });
      }
    }
    catch(e){
      print('Error toggling likes: $e');
    }


  }
  Future<void>addComment({required String authorId,required String postId,required String text,String? parentCommentId})async{
    try{
      final commentRef=_firestore.collection('tweets').doc(postId).collection('comments').doc();
      final newComment=CommentModel(createdAt: DateTime.now(), parentCommentId: parentCommentId,commentId: commentRef.id, text: text, authorId: authorId, postId: postId);
      await commentRef.set(newComment.toMap());
      await _firestore.collection('tweets').doc(postId).update({
        'commentCount':FieldValue.increment(1)
      });
      print("Comment added successfully");
    }
    catch(e){
      print('there is an error $e');
    }
  }
  Future<void> createTweet({required String text,required UserModel currentUser,String? imageUrl})async{
    emit(PostLoadingState());
    try{
      String tweetId=_firestore.collection('tweets').doc().id;
      TweetsModel  newTweet=TweetsModel(tweetId: tweetId, authorId: currentUser.uid, image: imageUrl,text: text, createdAt: DateTime.now(), likes: [], likeCount: 0, commentCount: 0);
      print("--- Tweet saved to Firestore ---");
      await _firestore.collection('tweets').doc(tweetId).set(newTweet.toMap());
      emit(PostSuccess());
    }
    catch(e){
      emit(PostFailureState(errorMessage: e.toString()));
    }
  }
}