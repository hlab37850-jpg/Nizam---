
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/widgets/n_card.dart';
import '../../../core/theme/app_colors.dart';
import '../../goals/providers/goals_provider.dart';
import '../../../data/models/app_models.dart';
class JournalCalendarScreen extends ConsumerStatefulWidget { const JournalCalendarScreen({super.key}); @override ConsumerState<JournalCalendarScreen> createState()=>_JournalCalendarScreenState(); }
class _JournalCalendarScreenState extends ConsumerState<JournalCalendarScreen>{
  DateTime _selected=DateTime.now();
  @override Widget build(BuildContext context){
    final journals=ref.watch(journalsProvider);
    final selectedJournals=journals.where((j)=> j.date.day==_selected.day && j.date.month==_selected.month && j.date.year==_selected.year).toList();
    return Scaffold(appBar: AppBar(title: const Text('المفكرة والمزاج')), body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children:[
      NCard(child: TableCalendar(locale:'ar', firstDay: DateTime.utc(2020,1,1), lastDay: DateTime.utc(2030,12,31), focusedDay:_selected, selectedDayPredicate:(d)=> isSameDay(d,_selected), onDaySelected:(sel,focused){ setState(()=>_selected=sel); }, calendarStyle: CalendarStyle(selectedDecoration: const BoxDecoration(color:AppColors.primary, shape:BoxShape.circle), todayDecoration: BoxDecoration(color:AppColors.primary.withOpacity(0.3), shape:BoxShape.circle)), headerStyle: const HeaderStyle(formatButtonVisible:false, titleCentered:true))),
      const SizedBox(height:16),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children:[Text('يوميات \${_selected.day}/\${_selected.month}', style: const TextStyle(fontWeight: FontWeight.w800)), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor:AppColors.primary, foregroundColor:Colors.white), onPressed: ()=>_add(), child: const Text('إضافة يومية'))]),
      const SizedBox(height:12),
      ...selectedJournals.map((j)=> Padding(padding: const EdgeInsets.only(bottom:12), child: NCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Row(children:[Text(j.mood, style: const TextStyle(fontSize:24)), const SizedBox(width:8), Text(j.date.toString().split(' ')[0], style: const TextStyle(color:Colors.grey, fontSize:12))]), const SizedBox(height:8), Text(j.content, style: const TextStyle(height:1.6))])))),
      if(selectedJournals.isEmpty) const Padding(padding: EdgeInsets.all(24), child: Text('لا يوجد يوميات في هذا اليوم', style: TextStyle(color:Colors.grey))),
    ])));
  }
  void _add(){ final content=TextEditingController(); String mood='😊'; showDialog(context: context, builder: (_)=> StatefulBuilder(builder: (ctx,setSt)=> AlertDialog(title: const Text('يومية جديدة'), content: Column(mainAxisSize:MainAxisSize.min, children:[Wrap(spacing:8, children:['😊','😔','😡','🥳','😴','🤔','❤️'].map((e)=> ChoiceChip(label: Text(e, style: const TextStyle(fontSize:20)), selected: mood==e, onSelected: (_)=> setSt(()=>mood=e))).toList()), const SizedBox(height:12), TextField(controller:content, maxLines:4, decoration: const InputDecoration(hintText:'كيف كان يومك؟', border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)))))]), actions:[TextButton(onPressed: ()=>Navigator.pop(ctx), child: const Text('إلغاء')), ElevatedButton(onPressed:(){ if(content.text.isEmpty) return; ref.read(journalsProvider.notifier).add(content.text, mood); Navigator.pop(ctx);}, child: const Text('حفظ'))] ))); }
}
