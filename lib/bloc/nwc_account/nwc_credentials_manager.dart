import 'package:nwc_app_final/services/keychain.dart';

class NWCCredentialsManager {
  static const String accountSecret = "account_secret";

  final KeyChain keyChain;

  NWCCredentialsManager({required this.keyChain});

  Future storeSecret({required String secret}) async {
    try {
      await _storeSecret(secret);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<String> restoreSecret() async {
    try {
      String? secret = await keyChain.read(accountSecret);
      return secret!;
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  /// Helper method to store the secret in the KeyChain.
  Future<void> _storeSecret(String secret) async {
    await keyChain.write(accountSecret, secret);
  }
}
