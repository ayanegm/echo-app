class TweetsModel {
final String tweetId;
final String authorId;
final String  text;
final String? image;
final DateTime createdAt;
final List<String>likes;
final int likeCount;
final int commentCount;

  TweetsModel({required this.tweetId, required this.authorId, required this.text, this.image, required this.createdAt, required this.likes, required this.likeCount, required this.commentCount});

factory TweetsModel.fromMap(Map<String,dynamic>map){
  return TweetsModel(tweetId: map['tweetId'], authorId: map['authorId'], text: map['text'], image: map['image'], createdAt: (map['createdAt'] as dynamic).toDate(), likes: List<String>.from(map['likes'] ?? []), likeCount: map['likeCount'], commentCount: map['commentCount']);
}

Map<String,dynamic>toMap(){
  return {
    'tweetId':tweetId,
    'authorId':authorId,
    'text':text,
    'image':image,
    'likes':likes,
    'createdAt':createdAt,
    'likeCount':likeCount,
    'commentCount':commentCount
  };
}
}
