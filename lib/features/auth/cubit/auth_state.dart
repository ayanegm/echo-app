sealed class AuthState {}
final class AuthInitial extends AuthState{}

final class AuthLoadingState extends AuthState{}

final class AuthSignedUp extends AuthState{
  final String email;
  final String uid;

  AuthSignedUp({required this.email, required this.uid});
  
}
final class AuthLoggedIn extends AuthState{
  
}
class AuthProfileSetupSuccess extends AuthState {}
final class AuthFailureState extends AuthState{
   final String errorMessage;
AuthFailureState({required this.errorMessage});
}
