import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class KeyChain {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Read data from secure storage based on the provided key.
  Future<String?> read(String key) {
    return _storage.read(key: key);
  }

  /// Write data to secure storage with the specified key-value pair.
  Future write(String key, String value) {
    return _storage.write(key: key, value: value);
  }

  /// Delete data from secure storage associated with the provided key.
  Future delete(String key) {
    return _storage.delete(key: key);
  }

  /// Clear all data from secure storage.
  Future clear() {
    return _storage.deleteAll();
  }
}
