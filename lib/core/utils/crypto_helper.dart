
import 'dart:convert';import 'dart:math';import 'package:crypto/crypto.dart';import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class CryptoHelper{
  static const _storage=FlutterSecureStorage(); static const _keyName='vault_key';
  static Future<String> _getOrCreateKey() async {
    var key=await _storage.read(key:_keyName);
    if(key==null){ final rand=Random.secure(); final bytes=List<int>.generate(32, (_)=>rand.nextInt(256)); key=base64Url.encode(bytes); await _storage.write(key:_keyName, value:key); }
    return key;
  }
  static Future<String> encrypt(String plain) async {
    final keyStr=await _getOrCreateKey(); final keyBytes=utf8.encode(keyStr); final plainBytes=utf8.encode(plain); final hmac=Hmac(sha256,keyBytes); final digest=hmac.convert(plainBytes); final combined=base64Encode(plainBytes)+'.'+digest.toString(); return base64Encode(utf8.encode(combined));
  }
  static Future<String> decrypt(String encrypted) async {
    try{ final keyStr=await _getOrCreateKey(); final keyBytes=utf8.encode(keyStr); final decoded=utf8.decode(base64Decode(encrypted)); final parts=decoded.split('.'); if(parts.length!=2) return '[خطأ]'; final plainBytes=base64Decode(parts[0]); final hmac=Hmac(sha256,keyBytes); final digest=hmac.convert(plainBytes); if(digest.toString()!=parts[1]) return '[تم التلاعب]'; return utf8.decode(plainBytes);} catch(_){ return '[خطأ]'; }
  }
}
