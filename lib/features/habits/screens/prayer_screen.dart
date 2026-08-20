
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/widgets/n_card.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/app_models.dart';
class PrayerScreen extends StatefulWidget { const PrayerScreen({super.key}); @override State<PrayerScreen> createState()=>_PrayerScreenState(); }
class _PrayerScreenState extends State<PrayerScreen>{
  final _box=Hive.box('prayers');
  String get _today=>DateTime.now().toIso8601String().split('T')[0];
  PrayerLog _getLog(){
    final raw=_box.get(_today);
    if(raw==null) return PrayerLog(date:_today, prayers:{'الفجر':false,'الظهر':false,'العصر':false,'المغرب':false,'العشاء':false}, water:0, sleepHours:0);
    return PrayerLog.fromMap(Map.from(raw));
  }
  void _save(PrayerLog log){ _box.put(_today, log.toMap()); setState((){}); }
  @override Widget build(BuildContext context){
    final log=_getLog();
    final prayers=log.prayers;
    final doneCount=prayers.values.where((v)=>v).length;
    return Scaffold(appBar: AppBar(title: const Text('الصلوات والعناية')), body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children:[
      NCard(color: AppColors.secondary, child: Row(children:[const Icon(Icons.mosque_rounded, color:Colors.white, size:32), const SizedBox(width:12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[const Text('صلوات اليوم', style: TextStyle(color:Colors.white, fontWeight: FontWeight.w800)), Text('\$doneCount/5 صلوات', style: const TextStyle(color:Colors.white70))])), CircularProgressIndicator(value:doneCount/5, color:Colors.white, backgroundColor:Colors.white24)])),
      const SizedBox(height:16),
      NCard(child: Column(children: prayers.keys.map((k)=> CheckboxListTile(value: prayers[k], title: Text(k, style: const TextStyle(fontWeight: FontWeight.w700)), activeColor:AppColors.secondary, onChanged:(v){ prayers[k]=v!; log.prayers=prayers; _save(log); })).toList())),
      const SizedBox(height:16),
      NCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
        const Text('شرب الماء', style: TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height:12),
        Row(children:[IconButton(onPressed:(){ if(log.water>0){ log.water--; _save(log);} }, icon: const Icon(Icons.remove_circle_outline)), Expanded(child: Center(child: Text('\${log.water} أكواب 💧', style: const TextStyle(fontSize:18, fontWeight: FontWeight.w800)))), IconButton(onPressed:(){ log.water++; _save(log); }, icon: const Icon(Icons.add_circle, color:AppColors.primary))]),
        const SizedBox(height:8),
        LinearProgressIndicator(value:(log.water/8).clamp(0,1), backgroundColor:Colors.grey.shade200, valueColor: const AlwaysStoppedAnimation(Color(0xFF06B6D4))),
      ])),
      const SizedBox(height:16),
      NCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
        const Text('النوم', style: TextStyle(fontWeight: FontWeight.w800)),
        Slider(value: log.sleepHours.clamp(0,12), min:0, max:12, divisions:24, activeColor:AppColors.primary, label:'\${log.sleepHours} ساعة', onChanged:(v){ log.sleepHours=v; _save(log); }),
        Text('\${log.sleepHours.toStringAsFixed(1)} ساعات نوم 😴', style: const TextStyle(color:Colors.grey)),
      ])),
    ])));
  }
}
