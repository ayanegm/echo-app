import 'package:bloc/bloc.dart';
import 'package:echo/features/auth/cubit/auth_state.dart';
import 'package:echo/features/auth/models/user_model.dart';
import 'package:echo/features/search/cubit/search_state.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class searchCubit extends Cubit<searchState> {
 final FirebaseFirestore _firestore=FirebaseFirestore.instance;
searchCubit() : super(searchInitial());


void onSearchChanged(String query)async{
  if(query.isEmpty){
    emit(searchInitial());
    return ;
  }
  emit(seachLoading());
  try{
  final querySnapshot=await _firestore.collection('users').where('searchName',isGreaterThanOrEqualTo: query).where('searchName',isLessThanOrEqualTo:'$query\uf8ff' ).get();
  final users=querySnapshot.docs.map((doc){
    return UserModel.fromMap(doc.data());
  }).toList();
  emit(searchSuccessState(users));
  }
  catch(e){
    emit(searchFailureState(errorMessage: e.toString()));
  }
  
}

  
}