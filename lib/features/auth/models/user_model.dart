import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid;
  final String name;
  final String? bio;
  final String email;
  final String? photoUrl;
  final String? link;
  final String? pushTokens;
  final String username;
  final String searchName;
  final List<String> followers;
  final List<String> following;
  final int followersCount;
  final int followingCount;
  UserModel({this.followersCount=0,required this.searchName, this.followingCount=0, required this.uid, required this.name, this.bio, required this.email, this.photoUrl, this.link,  this.pushTokens=null, required this.username, this.followers=const [], this.following=const []});
  factory UserModel.fromMap(Map<String,dynamic>map){
    return UserModel(followersCount:map['followersCount']??0 ,searchName: map['searchName'],followingCount: map['followingCount'] ??0,uid: map['uid'], name: map['name'], bio: map['bio'], email: map['email'], photoUrl: map['photoUrl'], link: map['link'], pushTokens: map['pushTokens'], username: map['username'], followers: List<String>.from(map['followers'] ?? []),
      following: List<String>.from(map['following'] ?? []),);
  }
  Map<String,dynamic> toMap(){
    return{
      'uid':uid,
      'name':name,
      'bio':bio,
      'email':email,
      'photoUrl':photoUrl,
      'link':link,
      'pushTokens':pushTokens,
      'username':username,
      'followers':followers,
      'following':following,
      'followersCount':followersCount,
      'followingCount':followingCount,
      'searchName':searchName
    };
  }
}