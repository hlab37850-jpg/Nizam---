
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/n_card.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/crypto_helper.dart';
import '../providers/vault_provider.dart';
class VaultListScreen extends ConsumerStatefulWidget { const VaultListScreen({super.key}); @override ConsumerState<VaultListScreen> createState()=>_VaultListScreenState(); }
class _VaultListScreenState extends ConsumerState<VaultListScreen>{
  @override Widget build(BuildContext context){
    final vaults=ref.watch(vaultProvider);
    return Scaffold(appBar: AppBar(title: const Text('الخزنة 🔒')), body: vaults.isEmpty? const Center(child: Text('لا يوجد أسرار بعد')): ListView.builder(padding: const EdgeInsets.all(16), itemCount: vaults.length, itemBuilder: (_,i){ final v=vaults[i]; return Padding(padding: const EdgeInsets.only(bottom:12), child: NCard(child: ListTile(title: Text(v.title, style: const TextStyle(fontWeight: FontWeight.w800)), subtitle: Text(v.createdAt.toString().split(' ')[0], style: const TextStyle(fontSize:12, color:Colors.grey)), trailing: IconButton(icon: const Icon(Icons.delete_outline, color:Colors.red), onPressed: ()=>ref.read(vaultProvider.notifier).delete(v.id)), onTap: () async { final plain=await CryptoHelper.decrypt(v.encryptedContent); if(!mounted) return; showDialog(context: context, builder: (_)=> AlertDialog(title: Text(v.title), content: Text(plain), actions:[TextButton(onPressed: ()=>Navigator.pop(context), child: const Text('إغلاق'))])); }))); }), floatingActionButton: FloatingActionButton.extended(backgroundColor:AppColors.primary, foregroundColor:Colors.white, onPressed: ()=>_add(), icon: const Icon(Icons.add), label: const Text('سر جديد')));
  }
  void _add(){ final title=TextEditingController(); final content=TextEditingController(); showDialog(context: context, builder: (_)=> AlertDialog(title: const Text('سر جديد مشفر'), content: Column(mainAxisSize:MainAxisSize.min, children:[TextField(controller:title, decoration: const InputDecoration(labelText:'العنوان')), const SizedBox(height:8), TextField(controller:content, maxLines:4, decoration: const InputDecoration(labelText:'المحتوى السري'))]), actions:[TextButton(onPressed: ()=>Navigator.pop(context), child: const Text('إلغاء')), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor:AppColors.primary, foregroundColor:Colors.white), onPressed: (){ if(title.text.isEmpty|| content.text.isEmpty) return; ref.read(vaultProvider.notifier).add(title.text, content.text); Navigator.pop(context); }, child: const Text('تشفير وحفظ'))])); }
}
