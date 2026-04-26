part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileSuccess extends ProfileState {
  final UserInfoModel userInfo;
  ProfileSuccess(this.userInfo);
}

final class ProfileError extends ProfileState {
  final String error;
  ProfileError(this.error);
}

class ProfileUpdating extends ProfileState {}

class ProfileUpdated extends ProfileState {
  final String message;
  ProfileUpdated(this.message);
}
