class CommentModel{
  final String commentId;
  final int likeCount;
  final String text;
  final String authorId;
  final String postId;
  final List<String>likes;
  final DateTime createdAt;
  final String? parentCommentId;
  CommentModel({this.parentCommentId, required this.createdAt,required this.commentId, this.likeCount=0, required this.text, required this.authorId, required this.postId, this.likes=const []});
  
factory  CommentModel.fromMap(Map<String,dynamic>map){
  return CommentModel(parentCommentId: map['parentCommentId'],createdAt: (map['createdAt'] as dynamic).toDate(), commentId: map['commentId'], likeCount: map['likeCount']??0,text: map['text'], authorId: map['authorId'], postId: map['postId'],likes: List<String>.from(map['likes'] ?? []));
}
Map<String,dynamic>toMap(){
  return{
    'commentId':commentId,
    'likeCount':likeCount,
    'text':text,
    'authorId':authorId,
    'postId':postId,
    'createdAt':createdAt,
    'parentCommentId':parentCommentId,
    'likes':likes
  };
}
}