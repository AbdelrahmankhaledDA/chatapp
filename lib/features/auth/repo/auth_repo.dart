import 'dart:typed_data';

import 'package:chatapp/core/DB/DB_failuires.dart';
import 'package:chatapp/core/DB/db_service.dart';
import 'package:chatapp/core/DB/storage_service.dart';
import 'package:chatapp/features/auth/models/user_info_model.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRepo {
  Future<Either<Failure, UserInfoModel>> logIn(String email, String password);
  Future<Either<Failure, UserInfoModel>> register(
    String email,
    String password,
    String phone,
    String userName,
    Uint8List? imageBytes,
  );
}

class AuthRepoImpl implements AuthRepo {
  final DbService dbService;
  final SupabaseClient supabase;
  final StorageService storageService;
  AuthRepoImpl(this.dbService, this.supabase, this.storageService);
  @override
  Future<Either<Failure, UserInfoModel>> logIn(
    String email,
    String password,
  ) async {
    try {
      final user = await dbService.signIn(email, password);

      if (user != null) {
        final result = await supabase
            .from('userInfo')
            .select()
            .eq('UID', user.id)
            .single();
        UserInfoModel userInfo = UserInfoModel.fromJson(result);

        return Right(userInfo);
      } else {
        return Left(DbFailure("Login failed"));
      }
    } on AuthException catch (e) {
      return Left(
        DbFailure(
          "An error occurred while logging in, message: ${e.message}, code: ${e.statusCode}",
        ),
      );
    } catch (e) {
      return Left(DbFailure("User profile not found: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, UserInfoModel>> register(
    String email,
    String password,
    String phone,
    String user_name,
    Uint8List? imageBytes,
  ) async {
    try {
      final user = await dbService.signUp(email, password);

      if (user != null) {
        final userId = user.id;
        String? imageUrl;
        if (imageBytes != null) {
          print("Uploading profile image...");
          imageUrl = await storageService.uploadFile(
            bucketName: 'images',
            path: 'user_profile/$userId.png',
            fileBytes: imageBytes,
          );
        }

        UserInfoModel userInfo = UserInfoModel(
          UID: userId,
          user_name: user_name,
          email: email,
          phone_num: phone,
          image_profile: imageUrl,
        );

        print("Auth success, starting insert into database...");

        await dbService.insert("userInfo", userInfo.toJson());
        print("Insert success with image: $imageUrl");

        return Right(userInfo);
      } else {
        return Left(DbFailure("Registration failed"));
      }
    } on AuthException catch (e) {
      return Left(DbFailure("An error occurred: ${e.message}"));
    } catch (e) {
      return Left(DbFailure(e.toString()));
    }
  }
}
