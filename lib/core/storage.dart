import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Storage {
  static const secure = FlutterSecureStorage();
  static const boxNames = <String>[
    'settings','tasks','projects','transactions','wallets','budgets',
    'debts','habits','prayers','vault','goals','journal','notes','water','sleep'
  ];

  static Future<void> init() async {
    await Hive.initFlutter();
    final stored = await secure.read(key: 'nizam_hive_key');
    late final Uint8List key;
    if (stored == null) {
      key = Uint8List.fromList(Hive.generateSecureKey());
      await secure.write(key: 'nizam_hive_key', value: base64UrlEncode(key));
    } else {
      key = Uint8List.fromList(base64Url.decode(stored));
    }
    for (final name in boxNames) {
      if (!Hive.isBoxOpen(name)) {
        await Hive.openBox(name, encryptionCipher: HiveAesCipher(key));
      }
    }
  }

  static Box box(String name) => Hive.box(name);

  static Future<String> exportJson() async {
    final root = <String, dynamic>{};
    for (final name in boxNames) {
      root[name] = Map<String, dynamic>.from(
        box(name).toMap().map((k, v) => MapEntry(k.toString(), v)),
      );
    }
    return jsonEncode(root);
  }

  static Future<void> importJson(String source) async {
    final decoded = jsonDecode(source);
    if (decoded is! Map) return;
    for (final name in boxNames) {
      final data = decoded[name];
      if (data is Map) {
        for (final entry in data.entries) {
          await box(name).put(entry.key, entry.value);
        }
      }
    }
  }
}
