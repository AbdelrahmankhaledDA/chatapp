import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:chatapp/features/auth/models/user_info_model.dart';
import 'package:chatapp/features/profile/repo/profile_repo.dart';
import 'package:meta/meta.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this.profileRepo) : super(ProfileInitial());
  ProfileRepo profileRepo;
  Future<void> getProfileData() async {
    emit(ProfileLoading());
    final result = await profileRepo.getProfileData();
    result.fold(
      (l) => emit(ProfileError(l.message)),
      (r) => emit(ProfileSuccess(r)),
    );
  }

  Future<void> updateProfileData(
    String name,
    String phone,

    Uint8List? imageBytes,
  ) async {
    emit(ProfileUpdating());
    final result = await profileRepo.updateProfileData(
      name: name,
      phone: phone,

      imageBytes: imageBytes,
    );
    result.fold(
      (l) => emit(ProfileError(l.message)),
      (r) => emit(ProfileUpdated(r)),
    );
  }
}
