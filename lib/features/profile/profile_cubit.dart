// lib/features/profile/profile_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echo/features/profile/profile_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  final Map<String, bool> _followingStates = {};
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // دالة لفحص حالة الزرار في الـ UI
  bool isUserFollowing(String userId) {
    return _followingStates[userId] ?? false;
  }

  void loadFollowingList() async {
    try {
      String currentUserId = _auth.currentUser!.uid;
      
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(currentUserId).get();

      if (userDoc.exists && userDoc.data() != null) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        
        List<dynamic> followingList = data['following'] ?? [];

        for (var id in followingList) {
          _followingStates[id.toString()] = true;
        }
      }

      emit(ProfileInitial()); 
      print("Following list loaded from Array! Total: ${_followingStates.length}");
    } catch (e) {
      print("Error loading following list: $e");
    }
  }

  void toggleFollow(String userId) async {
    bool currentStatus = _followingStates[userId] ?? false;
String currentUserId = _auth.currentUser!.uid;
    try {
      String currentUserId = _auth.currentUser!.uid;

      _followingStates[userId] = !currentStatus;
      emit(FollowStatusChanged(isFollowing: _followingStates[userId]!, userId: userId));

      if (currentStatus) {
        await _firestore.collection('users').doc(currentUserId).update({
          'following': FieldValue.arrayRemove([userId]),
          'followingCount': FieldValue.increment(-1),
        });
        await _firestore.collection('users').doc(userId).update({
        'followers': FieldValue.arrayRemove([currentUserId]),
        'followersCount': FieldValue.increment(-1),
      });
      } else {
        await _firestore.collection('users').doc(currentUserId).update({
          'following': FieldValue.arrayUnion([userId]),
          'followingCount': FieldValue.increment(1),
        });await _firestore.collection('users').doc(userId).update({
        'followers': FieldValue.arrayUnion([currentUserId]),
        'followersCount': FieldValue.increment(1),
      });
      }
      

    } catch (e) {
      _followingStates[userId] = currentStatus;
      emit(FollowStatusChanged(isFollowing: _followingStates[userId]!, userId: userId));
      emit(ProfileError(messagae: e.toString()));
    }
  }
}