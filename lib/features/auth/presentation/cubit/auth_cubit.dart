import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:chatapp/features/auth/models/user_info_model.dart';
import 'package:chatapp/features/auth/repo/auth_repo.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.authRepo) : super(AuthInitial());
  AuthRepo authRepo;
  Future<void> logIn(String email, String password) async {
    emit(AuthLoading());
    final result = await authRepo.logIn(email, password);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> register(
    String email,
    String password,
    String phone,
    String user_name,
    Uint8List? imageBytes,
  ) async {
    emit(AuthLoading());
    final result = await authRepo.register(
      email,
      password,
      phone,
      user_name,
      imageBytes,
    );
    result.fold((failure) => emit(AuthError(failure.message)), (user) {
      if (user != null) {
        emit(AuthSuccess(user));
      }
    });
  }
}
