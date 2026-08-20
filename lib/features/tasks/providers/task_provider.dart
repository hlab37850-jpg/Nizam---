
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../data/models/app_models.dart';
final tasksBoxProvider=Provider((ref)=>Hive.box('tasks'));
final projectsBoxProvider=Provider((ref)=>Hive.box('projects'));
final tasksProvider=StateNotifierProvider<TasksNotifier,List<TaskModel>>((ref){ final box=ref.watch(tasksBoxProvider); return TasksNotifier(box); });
final projectsProvider=StateNotifierProvider<ProjectsNotifier,List<ProjectModel>>((ref){ final box=ref.watch(projectsBoxProvider); return ProjectsNotifier(box); });
class TasksNotifier extends StateNotifier<List<TaskModel>>{
  final box; TasksNotifier(this.box): super(box.values.map((e)=>TaskModel.fromMap(Map.from(e))).toList()){ box.listenable().addListener(()=> state=box.values.map((e)=>TaskModel.fromMap(Map.from(e))).toList()); }
  void add(TaskModel t){ box.put(t.id,t.toMap()); }
  void updateStatus(String id,String s){ final m=Map.from(box.get(id)); m['status']=s; box.put(id,m); }
  void delete(String id){ box.delete(id); }
}
class ProjectsNotifier extends StateNotifier<List<ProjectModel>>{
  final box; ProjectsNotifier(this.box): super(box.values.map((e)=>ProjectModel.fromMap(Map.from(e))).toList()){
    box.listenable().addListener(()=> state=box.values.map((e)=>ProjectModel.fromMap(Map.from(e))).toList());
    if(state.isEmpty){ for(var n in ['العمل','شخصي','دراسة']){ final p=ProjectModel.create(n); box.put(p.id,p.toMap()); } }
  }
  void add(String name){ final p=ProjectModel.create(name); box.put(p.id,p.toMap()); }
}
