
import 'package:hive_flutter/hive_flutter.dart';
import 'constants.dart';
class HiveInit {
  static Future<void> init() async {
    await Hive.initFlutter();
    for (var b in AppConstants.boxes) { await Hive.openBox(b); }
    await Hive.openBox('settings');
  }
  static Box getBox(String name) => Hive.box(name);
}
