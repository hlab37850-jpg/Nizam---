
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import '../../../core/widgets/n_card.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/app_models.dart';
import '../providers/task_provider.dart';
class KanbanScreen extends ConsumerWidget {
  const KanbanScreen({super.key});
  @override Widget build(BuildContext context, WidgetRef ref){
    final tasks=ref.watch(tasksProvider);
    final todo=tasks.where((t)=>t.status=='todo').toList();
    final doing=tasks.where((t)=>t.status=='doing').toList();
    final done=tasks.where((t)=>t.status=='done').toList();
    return Scaffold(appBar: AppBar(title: const Text('Kanban Board - قابل للسحب')), body: DragAndDropLists(
      children:[
        _list('مهام', todo, AppColors.primary, ref),
        _list('قيد التنفيذ', doing, AppColors.warning, ref),
        _list('منجزة', done, AppColors.secondary, ref),
      ],
      onItemReorder: (oldItem, oldList, newItem, newList){
        TaskModel t; if(oldList==0) t=todo[oldItem]; else if(oldList==1) t=doing[oldItem]; else t=done[oldItem];
        String ns=newList==0?'todo': newList==1?'doing':'done';
        ref.read(tasksProvider.notifier).updateStatus(t.id, ns);
      },
      onListReorder: (_,__){},
      listPadding: const EdgeInsets.all(12), axis: Axis.horizontal, listWidth:300,
    ));
  }
  static DragAndDropList _list(String title, List<TaskModel> tasks, Color c, WidgetRef ref){
    return DragAndDropList(header: Padding(padding: const EdgeInsets.all(8), child: Row(children:[Container(width:8,height:8,decoration: BoxDecoration(color:c, shape:BoxShape.circle)), const SizedBox(width:8), Text(title, style: const TextStyle(fontWeight: FontWeight.w800)), const Spacer(), Text('\${tasks.length}', style: TextStyle(color:c, fontWeight: FontWeight.w800))])), children: tasks.map((t)=> DragAndDropItem(child: Padding(padding: const EdgeInsets.only(bottom:8), child: NCard(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Text(t.title, style: const TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height:4), Text('\${t.pomodoroCount} 🍅', style: const TextStyle(fontSize:11, color:Colors.grey))]))))).toList());
  }
}
