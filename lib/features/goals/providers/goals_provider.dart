
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../data/models/app_models.dart';
final goalsBoxProvider=Provider((ref)=>Hive.box('goals'));
final journalsBoxProvider=Provider((ref)=>Hive.box('journals'));
final notesBoxProvider=Provider((ref)=>Hive.box('notes'));
final goalsProvider=StateNotifierProvider<GoalsNotifier,List<GoalModel>>((ref)=>GoalsNotifier(ref.watch(goalsBoxProvider)));
final journalsProvider=StateNotifierProvider<JournalsNotifier,List<JournalModel>>((ref)=>JournalsNotifier(ref.watch(journalsBoxProvider)));
final notesProvider=StateNotifierProvider<NotesNotifier,List<NoteModel>>((ref)=>NotesNotifier(ref.watch(notesBoxProvider)));
class GoalsNotifier extends StateNotifier<List<GoalModel>>{
  final box; GoalsNotifier(this.box): super(box.values.map((e)=>GoalModel.fromMap(Map.from(e))).toList()){ box.listenable().addListener(()=> state=box.values.map((e)=>GoalModel.fromMap(Map.from(e))).toList()); }
  void add(String t){ final g=GoalModel.create(t); box.put(g.id,g.toMap()); }
  void updateProgress(String id,double p){ final m=Map.from(box.get(id)); m['progress']=p; if(p>=1) m['completed']=true; box.put(id,m); }
}
class JournalsNotifier extends StateNotifier<List<JournalModel>>{
  final box; JournalsNotifier(this.box): super(box.values.map((e)=>JournalModel.fromMap(Map.from(e))).toList()){ box.listenable().addListener(()=> state=box.values.map((e)=>JournalModel.fromMap(Map.from(e))).toList()); }
  void add(String c,String mood){ final j=JournalModel.create(c)..mood=mood; box.put(j.id,j.toMap()); }
}
class NotesNotifier extends StateNotifier<List<NoteModel>>{
  final box; NotesNotifier(this.box): super(box.values.map((e)=>NoteModel.fromMap(Map.from(e))).toList()){ box.listenable().addListener(()=> state=box.values.map((e)=>NoteModel.fromMap(Map.from(e))).toList()); }
  void add(String title,String content){ final n=NoteModel.create(title)..content=content; box.put(n.id,n.toMap()); }
}
