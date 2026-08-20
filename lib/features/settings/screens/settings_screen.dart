
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/widgets/n_card.dart';
import '../../../core/theme/app_colors.dart';
import '../../../app.dart';
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});
  @override Widget build(BuildContext context, WidgetRef ref){
    return Scaffold(appBar: AppBar(title: const Text('الإعدادات والنسخ الاحتياطي')), body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children:[
      NCard(child: Column(children:[
        ListTile(leading: const Icon(Icons.brightness_6_rounded, color:AppColors.primary), title: const Text('المظهر'), subtitle: const Text('فاتح / داكن / تلقائي'), trailing: DropdownButton<ThemeMode>(value: ref.watch(themeProvider), items: const [DropdownMenuItem(value:ThemeMode.light, child: Text('فاتح')), DropdownMenuItem(value:ThemeMode.dark, child: Text('داكن')), DropdownMenuItem(value:ThemeMode.system, child: Text('تلقائي'))], onChanged:(v){ if(v!=null) ref.read(themeProvider.notifier).state=v; })),
        const Divider(),
        ListTile(leading: const Icon(Icons.backup_rounded, color:AppColors.secondary), title: const Text('تصدير نسخة JSON'), subtitle: const Text('كل بياناتك في ملف واحد'), onTap: ()=>_export(context)),
        ListTile(leading: const Icon(Icons.restore_rounded, color:AppColors.warning), title: const Text('استيراد نسخة'), subtitle: const Text('استعادة من ملف JSON'), onTap: ()=>_importDialog(context)),
        ListTile(leading: const Icon(Icons.delete_forever_rounded, color:Colors.red), title: const Text('مسح كل البيانات'), subtitle: const Text('لا يمكن التراجع'), onTap: ()=>_clear(context)),
      ])),
      const SizedBox(height:16),
      const NCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
        Text('عن Nizam OS', style: TextStyle(fontWeight: FontWeight.w800, fontSize:16)),
        SizedBox(height:8),
        Text('نظام التشغيل الشخصي - Super App لإدارة الحياة Offline-first 100%\n\n• 10 Hive Boxes حقيقية\n• تشفير AES + بصمة\n• 7 أنظمة متكاملة\n• 18 شاشة\n• RTL عربي 100%\n• بدون Firebase أو تتبع', style: TextStyle(color:Colors.grey, height:1.6)),
      ])),
    ])));
  }
  Future<void> _export(BuildContext ctx) async {
    try{
      final Map<String,dynamic> all={};
      for(var name in ['tasks','projects','wallets','transactions','budgets','debts','habits','vault','goals','journals','notes','prayers','settings']){
        final box=Hive.box(name);
        all[name]=box.toMap().map((k,v)=> MapEntry(k.toString(), v));
      }
      final dir=await getApplicationDocumentsDirectory();
      final file=File('\${dir.path}/nizam_backup_\${DateTime.now().millisecondsSinceEpoch}.json');
      await file.writeAsString(jsonEncode(all));
      if(!ctx.mounted) return;
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('تم التصدير: \${file.path}')));
    } catch(e){ ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('خطأ: \$e'))); }
  }
  void _importDialog(BuildContext ctx){
    final ctrl=TextEditingController();
    showDialog(context: ctx, builder: (_)=> AlertDialog(title: const Text('استيراد JSON'), content: TextField(controller:ctrl, maxLines:6, decoration: const InputDecoration(hintText:'الصق محتوى ملف النسخ هنا', border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))))), actions:[TextButton(onPressed: ()=>Navigator.pop(ctx), child: const Text('إلغاء')), ElevatedButton(onPressed: () async {
      try{
        final data=jsonDecode(ctrl.text) as Map<String,dynamic>;
        for(var entry in data.entries){ final box=Hive.box(entry.key); await box.clear(); final map=entry.value as Map; for(var kv in map.entries){ await box.put(kv.key, kv.value); } }
        if(!ctx.mounted) return; Navigator.pop(ctx); ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('تم الاستيراد بنجاح، أعد تشغيل التطبيق')));
      } catch(e){ ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('خطأ: \$e'))); }
    }, child: const Text('استيراد'))]));
  }
  void _clear(BuildContext ctx){
    showDialog(context: ctx, builder: (_)=> AlertDialog(title: const Text('تأكيد المسح'), content: const Text('هل أنت متأكد من مسح كل البيانات؟ لا يمكن التراجع.'), actions:[TextButton(onPressed: ()=>Navigator.pop(ctx), child: const Text('إلغاء')), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor:Colors.red, foregroundColor:Colors.white), onPressed: () async { for(var name in ['tasks','projects','wallets','transactions','budgets','debts','habits','vault','goals','journals','notes','prayers']){ await Hive.box(name).clear(); } if(!ctx.mounted) return; Navigator.pop(ctx); ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('تم مسح كل البيانات'))); }, child: const Text('مسح'))]));
  }
}
