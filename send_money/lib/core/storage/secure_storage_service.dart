import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SecureStorageService {
  SecureStorageService()
      : _storage = const FlutterSecureStorage();

  static const _kAccessToken = 'access_token';

  final FlutterSecureStorage _storage;

  Future<void> saveToken(String token) =>
      _storage.write(key: _kAccessToken, value: token);

  Future<String?> getToken() => _storage.read(key: _kAccessToken);

  Future<void> deleteToken() => _storage.delete(key: _kAccessToken);
}
