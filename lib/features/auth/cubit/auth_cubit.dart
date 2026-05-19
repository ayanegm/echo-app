import 'package:bloc/bloc.dart';
import 'package:echo/features/auth/cubit/auth_state.dart';
import 'package:echo/features/auth/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth=FirebaseAuth.instance;
 final FirebaseFirestore _firestore=FirebaseFirestore.instance;
 UserModel?currentUser;
AuthCubit() : super(AuthInitial());
Future<void>signUpWithEmailAndPassword({required String email,required password})async{
    emit(AuthLoadingState());
      try {
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        emit(AuthSignedUp(email: email, uid: credential.user!.uid));
      } on FirebaseAuthException catch (e) {
        String errorMessage="something wrong happened";
        if (e.code == 'weak-password') {
          errorMessage='The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage='The account already exists for that email.';
        }
        else{
          errorMessage=e.message??errorMessage;
        }
        emit(AuthFailureState(errorMessage: errorMessage));
      } catch (e) {
        emit(AuthFailureState(errorMessage: e.toString()));
      }

}
Future<void> setupUserProfile({required String name,required String username,required String email,required String uid,String? bio,String? link})async{
    emit(AuthLoadingState());
    try{
      final usernmaeCheck=await _firestore.collection('users').where('username',isEqualTo: username.trim().toLowerCase()).get();
      if(usernmaeCheck.docs.isNotEmpty){
        emit(AuthFailureState(errorMessage: "username is already used"));
        return;
      }
      UserModel newUser=UserModel(uid:uid , searchName: name.trim().toLowerCase(),name: name, email: email, username: username.trim().toLowerCase(),bio:bio,link: link, );
      await _firestore.collection('users').doc(uid).set(newUser.toMap());
      emit(AuthProfileSetupSuccess());
    }
    catch(e){
      emit(AuthFailureState(errorMessage: e.toString()));
    }
}
  Future<void>signInWithEmailAndPassword({required String email,required String password})async{
    emit(AuthLoadingState());
    try{

final credential =await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email,
                    password: password
                  );
                  final userDoc = await _firestore.collection('users').doc(credential.user!.uid).get();
    if (userDoc.exists) {
      currentUser = UserModel.fromMap(userDoc.data()!);
    }
      emit(AuthLoggedIn());
    }on FirebaseAuthException catch(e){
      emit(AuthFailureState(errorMessage: e.message??"somwthing went wrong"));
    }
  }
}