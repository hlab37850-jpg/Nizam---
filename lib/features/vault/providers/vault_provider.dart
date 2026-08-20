
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../data/models/app_models.dart';
import '../../../core/utils/crypto_helper.dart';
final vaultBoxProvider=Provider((ref)=>Hive.box('vault'));
final vaultProvider=StateNotifierProvider<VaultNotifier,List<VaultModel>>((ref)=>VaultNotifier(ref.watch(vaultBoxProvider)));
class VaultNotifier extends StateNotifier<List<VaultModel>>{
  final box; VaultNotifier(this.box): super(box.values.map((e)=>VaultModel.fromMap(Map.from(e))).toList()){ box.listenable().addListener(()=> state=box.values.map((e)=>VaultModel.fromMap(Map.from(e))).toList()); }
  Future<void> add(String title,String plain) async { final enc=await CryptoHelper.encrypt(plain); final v=VaultModel(id:DateTime.now().millisecondsSinceEpoch.toString(), title:title, encryptedContent:enc, createdAt:DateTime.now()); box.put(v.id,v.toMap()); }
  void delete(String id){ box.delete(id); }
}
