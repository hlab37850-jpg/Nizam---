import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../core/models.dart';
import '../core/storage.dart';
import '../services/notifications.dart';

final themeProvider = StateProvider<bool>((ref)=>false);
final tasksProvider = StateNotifierProvider<TasksNotifier,List<Task>>((ref)=>TasksNotifier());
class TasksNotifier extends StateNotifier<List<Task>> {
  final box=Storage.box('tasks'); final uuid=const Uuid();
  TasksNotifier():super([]){ _load(); }
  void _load(){ state=box.values.map((e)=>Task.fromMap(Map<String,dynamic>.from(e as Map))).toList(); }
  Future<void> add(String title,{String project=''}) async {
    final t=Task(id:uuid.v4(),title:title,project:project,createdAt:DateTime.now());
    await box.put(t.id,t.toMap()); state=[...state,t];
  }
  Future<void> toggle(Task t) async {
    final n=Task(id:t.id,title:t.title,project:t.project,status:t.done?'todo':'done',done:!t.done,createdAt:t.createdAt);
    await box.put(t.id,n.toMap()); _load();
  }
  Future<void> move(Task t,String status) async {
    final n=Task(id:t.id,title:t.title,project:t.project,status:status,done:status=='done',createdAt:t.createdAt);
    await box.put(t.id,n.toMap()); _load();
  }
  Future<void> notify(Task t)=>NotificationService.show('مهمة: ${t.title}','حان وقت إنجاز المهمة');
}
final financeProvider=Provider<double>((ref){
  final b=Storage.box('transactions'); double total=0;
  for(final v in b.values){ final m=Map<String,dynamic>.from(v as Map); final a=(m['amount'] as num).toDouble(); total += m['type']=='income'?a:-a; }
  return total;
});
final habitsProvider=StateProvider<Map<String,bool>>((ref)=>{});
