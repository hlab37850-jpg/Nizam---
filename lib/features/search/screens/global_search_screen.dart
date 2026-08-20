
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/widgets/n_card.dart';
import '../../../data/models/app_models.dart';
class GlobalSearchScreen extends StatefulWidget { const GlobalSearchScreen({super.key}); @override State<GlobalSearchScreen> createState()=>_GlobalSearchScreenState(); }
class _GlobalSearchScreenState extends State<GlobalSearchScreen>{
  String _q='';
  @override Widget build(BuildContext context){
    final tasks=Hive.box('tasks').values.map((e)=>TaskModel.fromMap(Map.from(e))).where((t)=> t.title.contains(_q)).toList();
    final notes=Hive.box('notes').values.map((e)=>NoteModel.fromMap(Map.from(e))).where((n)=> n.title.contains(_q) || n.content.contains(_q)).toList();
    final trans=Hive.box('transactions').values.map((e)=>TransactionModel.fromMap(Map.from(e))).where((t)=> t.category.contains(_q)).toList();
    return Scaffold(appBar: AppBar(title: const Text('بحث شامل')), body: Column(children:[
      Padding(padding: const EdgeInsets.all(16), child: TextField(onChanged:(v)=>setState(()=>_q=v), decoration: InputDecoration(hintText:'ابحث في كل شيء... مهام، مصاريف، ملاحظات', prefixIcon: const Icon(Icons.search_rounded), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))))),
      Expanded(child: ListView(padding: const EdgeInsets.all(16), children:[
        if(tasks.isNotEmpty)...[const Text('المهام', style: TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height:8), ...tasks.map((t)=> NCard(child: Text(t.title)))],
        if(notes.isNotEmpty)...[const SizedBox(height:16), const Text('الملاحظات', style: TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height:8), ...notes.map((n)=> NCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Text(n.title, style: const TextStyle(fontWeight: FontWeight.w700)), Text(n.content, maxLines:2)])))],
        if(trans.isNotEmpty)...[const SizedBox(height:16), const Text('المعاملات', style: TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height:8), ...trans.map((t)=> NCard(child: Text('\${t.category} - \${t.amount}')))],
        if(_q.isNotEmpty && tasks.isEmpty && notes.isEmpty && trans.isEmpty) const Padding(padding: EdgeInsets.all(24), child: Center(child: Text('لا نتائج'))),
        if(_q.isEmpty) const Padding(padding: EdgeInsets.all(24), child: Center(child: Text('اكتب للبحث في كل أنظمة Nizam OS'))),
      ])),
    ]));
  }
}
