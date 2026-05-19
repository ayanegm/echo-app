sealed class ProfileState{}

final class ProfileInitial extends ProfileState{}

final class ProfileLoadingState extends ProfileState{}

class  FollowStatusChanged extends ProfileState{
final bool isFollowing;
final String userId;
  FollowStatusChanged({required this.userId, required this.isFollowing});

}
class ProfileError extends ProfileState{
  final String messagae;

  ProfileError({required this.messagae});
  
}
