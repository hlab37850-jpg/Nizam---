import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Storage {
  static const secure = FlutterSecureStorage();
  static const boxNames = [
    'settings','tasks','projects','transactions','wallets','budgets',
    'debts','habits','prayers','vault','goals','journal','notes','water','sleep'
  ];

  static Future<void> init() async {
    await Hive.initFlutter();
    Uint8List? key;
    final stored = await secure.read(key: 'hive_key');
    if (stored == null) {
      key = Hive.generateSecureKey();
      await secure.write(key: 'hive_key', value: base64UrlEncode(key));
    } else {
      key = Uint8List.fromList(base64Url.decode(stored));
    }
    for (final name in boxNames) {
      await Hive.openBox(name, encryptionCipher: HiveAesCipher(key));
    }
  }

  static Box box(String name) => Hive.box(name);

  static Future<String> exportJson() async {
    final map = <String, dynamic>{};
    for (final name in boxNames) {
      map[name] = box(name).toMap().map((k,v)=>MapEntry(k.toString(), v));
    }
    return jsonEncode(map);
  }

  static Future<void> importJson(String json) async {
    final root = jsonDecode(json) as Map<String,dynamic>;
    for (final name in boxNames) {
      final data = root[name];
      if (data is Map) {
        final b = box(name);
        for (final e in data.entries) {
          await b.put(e.key, e.value);
        }
      }
    }
  }
}
