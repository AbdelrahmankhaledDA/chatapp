import 'package:chatapp/core/DB/db_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService implements DbService {
  @override
  SupabaseClient get client => Supabase.instance.client;

  @override
  Future<User?> signUp(String email, String password) async {
    try {
      final response = await client.auth.signUp(
        email: email,
        password: password,
      );
      return response.user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User?> signIn(String email, String password) async {
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response.user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await client.auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> insert(String table, Map<String, dynamic> data) async {
    try {
      await client.from(table).insert(data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> fetchAllDatabyFilterNeq(
    String table,
    String column,
    String value,
  ) async {
    try {
      final response = await client.from(table).select().neq(column, value);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getUserData(
    String table,
    String column,
    String value,
  ) async {
    try {
      final response = await client
          .from(table)
          .select()
          .eq(column, value)
          .single();

      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateUserData(
    String table,
    String column,
    String value,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await client.from(table).update(data).eq(column, value);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> upadte(
    String table,
    Map<String, dynamic> data,
    String column,
    String value,
  ) async {
    try {
      final response = await client.from(table).update(data).eq(column, value);
    } catch (e) {
      rethrow;
    }
  }
}
