
import 'package:echo/features/auth/models/user_model.dart';

sealed class searchState{}

final class searchInitial extends searchState{}
final class seachLoading extends searchState{}

final class searchFailureState extends searchState{
  String? errorMessage;
searchFailureState({required this.errorMessage});
}

final class searchSuccessState extends searchState{
  final List<UserModel>users;
  searchSuccessState(this.users);
}