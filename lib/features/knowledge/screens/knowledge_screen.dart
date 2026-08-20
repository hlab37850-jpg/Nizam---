
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/n_card.dart';
import '../../../core/theme/app_colors.dart';
import '../../goals/providers/goals_provider.dart';
class KnowledgeScreen extends ConsumerWidget {
  const KnowledgeScreen({super.key});
  @override Widget build(BuildContext context, WidgetRef ref){
    final notes=ref.watch(notesProvider);
    return Scaffold(appBar: AppBar(title: const Text('المعرفة - ملاحظات')), body: notes.isEmpty? const Center(child: Text('لا يوجد ملاحظات')): ListView.builder(padding: const EdgeInsets.all(16), itemCount: notes.length, itemBuilder: (_,i){ final n=notes[i]; return Padding(padding: const EdgeInsets.only(bottom:12), child: NCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Text(n.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize:16)), const SizedBox(height:8), Text(n.content, maxLines:3, overflow: TextOverflow.ellipsis, style: const TextStyle(color:Colors.grey, height:1.5)), const SizedBox(height:8), Wrap(spacing:6, children: n.tags.map((t)=> Container(padding: const EdgeInsets.symmetric(horizontal:8, vertical:2), decoration: BoxDecoration(color:AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Text(t, style: const TextStyle(fontSize:11, color:AppColors.primary)))).toList())]))); }), floatingActionButton: FloatingActionButton(backgroundColor:AppColors.primary, foregroundColor:Colors.white, onPressed: ()=>_add(context, ref), child: const Icon(Icons.add)));
  }
  void _add(BuildContext ctx, WidgetRef ref){ final title=TextEditingController(); final content=TextEditingController(); showDialog(context: ctx, builder: (_)=> AlertDialog(title: const Text('ملاحظة جديدة'), content: Column(mainAxisSize:MainAxisSize.min, children:[TextField(controller:title, decoration: const InputDecoration(labelText:'العنوان')), const SizedBox(height:8), TextField(controller:content, maxLines:5, decoration: const InputDecoration(labelText:'المحتوى'))]), actions:[TextButton(onPressed: ()=>Navigator.pop(ctx), child: const Text('إلغاء')), ElevatedButton(onPressed:(){ if(title.text.isEmpty) return; ref.read(notesProvider.notifier).add(title.text, content.text); Navigator.pop(ctx);}, child: const Text('حفظ'))])); }
}
