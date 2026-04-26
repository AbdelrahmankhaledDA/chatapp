import 'package:supabase_flutter/supabase_flutter.dart';

abstract class DbService {
  dynamic get client;
  Future<User?> signUp(String email, String password);
  Future<User?> signIn(String email, String password);
  Future<void> signOut();
  Future<void> insert(String table, Map<String, dynamic> data);
  Future<List<Map<String, dynamic>>> fetchAllDatabyFilterNeq(
    String table,
    String column,
    String value,
  );
  Future<Map<String, dynamic>> getUserData(
    String table,
    String column,
    String value,
  );
  Future<void> updateUserData(
    String table,
    String column,
    String value,
    Map<String, dynamic> data,
  );
  Future<void> upadte(
    String table,
    Map<String, dynamic> data,
    String column,
    String value,
  );
}
