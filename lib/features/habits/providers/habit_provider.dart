
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../data/models/app_models.dart';
final habitsBoxProvider=Provider((ref)=>Hive.box('habits'));
final prayersBoxProvider=Provider((ref)=>Hive.box('prayers'));
final habitsProvider=StateNotifierProvider<HabitsNotifier,List<HabitModel>>((ref)=>HabitsNotifier(ref.watch(habitsBoxProvider)));
class HabitsNotifier extends StateNotifier<List<HabitModel>>{
  final box; HabitsNotifier(this.box): super(box.values.map((e)=>HabitModel.fromMap(Map.from(e))).toList()){
    box.listenable().addListener(()=> state=box.values.map((e)=>HabitModel.fromMap(Map.from(e))).toList());
    if(state.isEmpty){ for(var n in ['قراءة','رياضة','ماء']){ final h=HabitModel.create(n); box.put(h.id,h.toMap()); } }
  }
  void toggle(String id){
    final today=DateTime.now().toIso8601String().split('T')[0];
    final m=Map.from(box.get(id));
    List<String> dates=List<String>.from(m['completedDates']??[]);
    if(dates.contains(today)){ dates.remove(today); m['streak']=(m['streak']??1)-1; } else { dates.add(today); m['streak']=(m['streak']??0)+1; }
    m['completedDates']=dates; box.put(id,m);
  }
  void add(String name){ final h=HabitModel.create(name); box.put(h.id,h.toMap()); }
}
