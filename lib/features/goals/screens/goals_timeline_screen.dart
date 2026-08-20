
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/n_card.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/goals_provider.dart';
class GoalsTimelineScreen extends ConsumerWidget {
  const GoalsTimelineScreen({super.key});
  @override Widget build(BuildContext context, WidgetRef ref){
    final goals=ref.watch(goalsProvider);
    return Scaffold(appBar: AppBar(title: const Text('الأهداف - Timeline')), body: goals.isEmpty? const Center(child: Text('لا يوجد أهداف بعد')): ListView.builder(padding: const EdgeInsets.all(16), itemCount: goals.length, itemBuilder: (_,i){
      final g=goals[i];
      return Padding(padding: const EdgeInsets.only(bottom:16), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children:[
        Column(children:[Container(width:16,height:16, decoration: BoxDecoration(color:g.completed? AppColors.secondary: AppColors.primary, shape:BoxShape.circle)), if(i!=goals.length-1) Container(width:2,height:80, color:Colors.grey.shade300)]),
        const SizedBox(width:12),
        Expanded(child: NCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children:[Expanded(child: Text(g.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize:16))), Text('\${(g.progress*100).toStringAsFixed(0)}%', style: const TextStyle(color:AppColors.primary, fontWeight: FontWeight.w800))]),
          if(g.desc!=null) Padding(padding: const EdgeInsets.only(top:4), child: Text(g.desc!, style: const TextStyle(color:Colors.grey, fontSize:12))),
          const SizedBox(height:12),
          LinearProgressIndicator(value:g.progress, backgroundColor:Colors.grey.shade200, valueColor: AlwaysStoppedAnimation(g.completed? AppColors.secondary: AppColors.primary), borderRadius: BorderRadius.circular(8), minHeight:6),
          const SizedBox(height:12),
          Slider(value:g.progress, min:0, max:1, activeColor:AppColors.primary, onChanged:(v)=>ref.read(goalsProvider.notifier).updateProgress(g.id, v)),
          Text('الهدف: \${g.targetDate.toString().split(' ')[0]}', style: const TextStyle(fontSize:11, color:Colors.grey)),
        ]))),
      ]));
    }), floatingActionButton: FloatingActionButton(backgroundColor:AppColors.primary, foregroundColor:Colors.white, onPressed: ()=>_add(context, ref), child: const Icon(Icons.add)));
  }
  void _add(BuildContext ctx, WidgetRef ref){ final c=TextEditingController(); showDialog(context: ctx, builder: (_)=> AlertDialog(title: const Text('هدف جديد'), content: TextField(controller:c, decoration: const InputDecoration(hintText:'مثال: حفظ 20 جزء')), actions:[TextButton(onPressed: ()=>Navigator.pop(ctx), child: const Text('إلغاء')), ElevatedButton(onPressed:(){ if(c.text.isEmpty) return; ref.read(goalsProvider.notifier).add(c.text); Navigator.pop(ctx);}, child: const Text('إضافة'))])); }
}
