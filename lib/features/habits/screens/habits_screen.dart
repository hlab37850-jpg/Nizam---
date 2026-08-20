
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/n_card.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/habit_provider.dart';
import 'prayer_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../data/models/app_models.dart';
class HabitsScreen extends ConsumerWidget {
  const HabitsScreen({super.key});
  @override Widget build(BuildContext context, WidgetRef ref){
    final habits=ref.watch(habitsProvider);
    final today=DateTime.now().toIso8601String().split('T')[0];
    return Scaffold(body: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(16,8,16,100), child: Column(children: [
      Row(children:[Expanded(child: NCard(color:AppColors.primary, child: Column(children:[const Icon(Icons.local_fire_department_rounded, color:Colors.white, size:32), const SizedBox(height:8), Text('\${habits.fold(0,(a,b)=>a+b.streak)} 🔥', style: const TextStyle(color:Colors.white, fontWeight: FontWeight.w900, fontSize:20)), const Text('مجموع الستريك', style: TextStyle(color:Colors.white70, fontSize:12))]))), const SizedBox(width:12), Expanded(child: NCard(onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const PrayerScreen())), child: Column(children:[const Icon(Icons.mosque_rounded, color:AppColors.secondary, size:32), const SizedBox(height:8), const Text('الصلوات', style: TextStyle(fontWeight: FontWeight.w800)), const Text('تتبع 5 صلوات', style: TextStyle(color:Colors.grey, fontSize:11))])))]),
      const SizedBox(height:16),
      GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2, crossAxisSpacing:12, mainAxisSpacing:12, childAspectRatio:1.1), shrinkWrap:true, physics: const NeverScrollableScrollPhysics(), itemCount: habits.length, itemBuilder: (_,i){
        final h=habits[i]; final done=h.completedDates.contains(today);
        return NCard(padding: const EdgeInsets.all(16), onTap: ()=>ref.read(habitsProvider.notifier).toggle(h.id), child: Column(children:[
          Container(width:120,height:120, decoration: BoxDecoration(shape:BoxShape.circle, color: done? AppColors.secondary.withOpacity(0.15): Colors.grey.shade100, border: Border.all(color: done? AppColors.secondary: Colors.grey.shade300, width:3)), child: Center(child: Column(mainAxisSize:MainAxisSize.min, children:[Text(h.icon, style: const TextStyle(fontSize:32)), const SizedBox(height:4), Text(done?'تم':'', style: const TextStyle(color:AppColors.secondary, fontWeight: FontWeight.w800))]))),
          const SizedBox(height:12),
          Text(h.name, style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height:4),
          Row(mainAxisAlignment: MainAxisAlignment.center, children:[const Icon(Icons.local_fire_department, size:14, color:Colors.orange), Text('\${h.streak} يوم', style: const TextStyle(fontSize:12, color:Colors.grey))]),
        ]));
      }),
      const SizedBox(height:16),
      NCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
        const Text('إضافة عادة جديدة', style: TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height:12),
        _AddHabitField(),
      ])),
    ])), floatingActionButton: FloatingActionButton.extended(backgroundColor:AppColors.secondary, foregroundColor:Colors.white, onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const PrayerScreen())), label: const Text('الصلوات والماء والنوم'), icon: const Icon(Icons.water_drop_rounded)));
  }
}
class _AddHabitField extends ConsumerStatefulWidget { @override ConsumerState<_AddHabitField> createState()=>_AddHabitFieldState(); }
class _AddHabitFieldState extends ConsumerState<_AddHabitField>{ final _c=TextEditingController(); @override Widget build(BuildContext context){ return Row(children:[Expanded(child: TextField(controller:_c, decoration: const InputDecoration(hintText:'مثال: قراءة 20 صفحة', border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)))))), const SizedBox(width:8), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor:AppColors.primary, foregroundColor:Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), onPressed:(){ if(_c.text.trim().isEmpty) return; ref.read(habitsProvider.notifier).add(_c.text.trim()); _c.clear(); }, child: const Text('إضافة'))]); } }
