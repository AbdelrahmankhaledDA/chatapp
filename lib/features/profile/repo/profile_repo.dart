import 'dart:typed_data';

import 'package:chatapp/core/DB/DB_failuires.dart';
import 'package:chatapp/core/DB/db_service.dart';
import 'package:chatapp/core/DB/storage_service.dart';
import 'package:chatapp/features/auth/models/user_info_model.dart';
import 'package:dartz/dartz.dart';

abstract class ProfileRepo {
  Future<Either<Failure, UserInfoModel>> getProfileData();
  Future<Either<Failure, String>> updateProfileData({
    required String name,
    required String phone,

    Uint8List? imageBytes,
  });
}

class ProfileRepoImpl implements ProfileRepo {
  DbService dbService;
  final StorageService storageService;
  ProfileRepoImpl(this.dbService, this.storageService);
  @override
  Future<Either<Failure, UserInfoModel>> getProfileData() async {
    try {
      final userId = dbService.client.auth.currentUser?.id;
      final response = await dbService.getUserData("userInfo", "UID", userId);
      return Right(UserInfoModel.fromJson(response));
    } catch (e) {
      return Left(
        DbFailure("An Error Occured while fetching profile data: $e"),
      );
    }
  }

  @override
  Future<Either<Failure, String>> updateProfileData({
    required String name,
    required String phone,
    // required String email,
    Uint8List? imageBytes,
  }) async {
    try {
      final userId = dbService.client.auth.currentUser?.id;
      if (userId == null) return Left(DbFailure("User not found"));

      String? imageUrl;

      if (imageBytes != null) {
        imageUrl = await storageService.uploadFile(
          bucketName: 'images',
          path: 'profile_pics/$userId.png',
          fileBytes: imageBytes,
        );
      }

      Map<String, dynamic> updateData = {"user_name": name, "phone_num": phone};

      if (imageUrl != null) {
        updateData["image_profile"] = imageUrl;
      }

      await dbService.updateUserData("userInfo", "UID", userId, updateData);

      return const Right("Profile Updated Successfully");
    } catch (e) {
      return Left(
        DbFailure("An Error Occured while updating profile data: $e"),
      );
    }
  }
}
