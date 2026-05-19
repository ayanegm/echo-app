sealed class PostState{}

final class PostInitial extends PostState{}

final class PostLoadingState extends PostState{}



class PostSuccess extends PostState {}
final class PostFailureState extends PostState{
   final String errorMessage;
PostFailureState({required this.errorMessage});
}
