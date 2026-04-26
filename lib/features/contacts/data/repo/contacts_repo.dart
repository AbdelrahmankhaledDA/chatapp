import 'package:chatapp/core/DB/DB_failuires.dart';
import 'package:chatapp/core/DB/db_service.dart';
import 'package:chatapp/core/DB/supabase_service.dart';
import 'package:chatapp/features/auth/models/user_info_model.dart';
import 'package:dartz/dartz.dart';

abstract class ContactsRepo {
  Future<Either<Failure, List<UserInfoModel>>> getAllContacts();
  //Future<Either<Failure, void>> addContact(Contact contact);
}

class ContactsRepoImpl implements ContactsRepo {
  DbService dbService;
  ContactsRepoImpl(this.dbService);
  @override
  Future<Either<Failure, List<UserInfoModel>>> getAllContacts() async {
    try {
      final userId = SupabaseService().client.auth.currentUser!.id;
      final response = await dbService.fetchAllDatabyFilterNeq(
        "userInfo",
        "UID",
        userId,
      );
      final users = response
          .map((data) => UserInfoModel.fromJson(data))
          .toList();
      return Right(users);
    } catch (e) {
      return Left(DbFailure(e.toString()));
    }
  }
}
