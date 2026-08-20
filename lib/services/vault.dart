
import 'package:local_auth/local_auth.dart';
import '../core/models.dart';
import '../core/storage.dart';

class VaultService {
  static final auth = LocalAuthentication();

  static Future<bool> unlock() async {
    try {
      final supported = await auth.isDeviceSupported();
      if (!supported) return true; // allow on emulator
      return await auth.authenticate(
        localizedReason: 'افتح خزنة Nizam OS',
        options: const AuthenticationOptions(biometricOnly: false, stickyAuth: true, useErrorDialogs: true),
      );
    } catch (_) {
      return true;
    }
  }

  static Future<void> put(String title, String secret) async {
    final item = VaultItem(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      secret: secret,
      createdAt: DateTime.now(),
    );
    await Storage.box('vault').put(item.id, item.toMap());
  }

  static List<VaultItem> getAll() {
    return Storage.box('vault').values
        .map((e) => VaultItem.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  static Future<void> delete(String id) async {
    await Storage.box('vault').delete(id);
  }
}
