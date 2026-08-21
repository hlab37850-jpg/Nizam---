import 'package:local_auth/local_auth.dart';
import '../core/storage.dart';

class VaultService {
  static final auth = LocalAuthentication();
  static Future<bool> unlock() async {
    try {
      final supported = await auth.isDeviceSupported();
      if (!supported) return false;
      return await auth.authenticate(
        localizedReason: 'افتح خزنة Nizam OS',
        options: const AuthenticationOptions(biometricOnly: false, stickyAuth: true, useErrorDialogs: true),
      );
    } catch (_) { return false; }
  }
  static Future<void> put(String title, String secret) async {
    await Storage.box('vault').put(DateTime.now().microsecondsSinceEpoch.toString(), {'title':title,'secret':secret});
  }
}
