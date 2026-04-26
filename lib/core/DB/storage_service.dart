import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  final SupabaseClient _client;

  StorageService(this._client);

  Future<String?> uploadFile({
    required String bucketName,
    required String path,
    required Uint8List fileBytes,
  }) async {
    try {
      await _client.storage
          .from(bucketName)
          .uploadBinary(
            path,
            fileBytes,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
          );

      final String publicUrl = _client.storage
          .from(bucketName)
          .getPublicUrl(path);

      return publicUrl;
    } catch (e) {
      print("Storage Error: $e");
      return null;
    }
  }

  Future<void> deleteFile(String bucketName, String path) async {
    await _client.storage.from(bucketName).remove([path]);
  }
}
