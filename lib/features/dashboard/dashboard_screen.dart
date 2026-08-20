
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/widgets/n_card.dart';
import '../../core/theme/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../data/models/app_models.dart';
import '../tasks/screens/task_detail_screen.dart';
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  @override Widget build(BuildContext context){
    final tasksBox=Hive.box('tasks'); final transBox=Hive.box('transactions'); final habitsBox=Hive.box('habits');
    return ValueListenableBuilder(valueListenable: tasksBox.listenable(), builder: (_,__,___){
      final tasks=tasksBox.values.map((e)=>TaskModel.fromMap(Map.from(e))).toList();
      final today=tasks.where((t)=>t.status!='done').take(5).toList();
      final done=tasks.where((t)=>t.status=='done').length;
      return ValueListenableBuilder(valueListenable: transBox.listenable(), builder: (_,__,___){
        final trans=transBox.values.map((e)=>TransactionModel.fromMap(Map.from(e))).toList();
        final expense=trans.where((t)=>t.type=='expense').fold(0.0,(a,b)=>a+b.amount);
        final habits=habitsBox.values.map((e)=>HabitModel.fromMap(Map.from(e))).toList();
        final avg=habits.isEmpty?0:habits.map((h){final todayStr=DateTime.now().toIso8601String().split('T')[0]; return h.completedDates.contains(todayStr)?1:0;}).fold(0,(a,b)=>a+b);
        return SingleChildScrollView(padding: const EdgeInsets.fromLTRB(16,8,16,100), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('أهلاً، صباح الخير 👋', style: TextStyle(fontSize:22, fontWeight: FontWeight.w800)),
          const SizedBox(height:4),
          Text('\${DateTime.now().day}/\${DateTime.now().month} - لديك \${today.length} مهام اليوم', style: const TextStyle(color:Colors.grey)),
          const SizedBox(height:16),
          GridView.count(crossAxisCount:2, shrinkWrap:true, physics: const NeverScrollableScrollPhysics(), crossAxisSpacing:12, mainAxisSpacing:12, childAspectRatio:1.15, children: [
            _bento('المهام','\$done مكتملة',Icons.check_circle_rounded,AppColors.primary,'\${tasks.length}'),
            _bento('المصاريف','\${expense.toStringAsFixed(0)} ر.س',Icons.wallet_rounded,AppColors.warning,'\${trans.length}'),
            _bento('العادات','\$avg/\${habits.length} اليوم',Icons.repeat_rounded,AppColors.secondary,'🔥'),
            _bento('الإنتاجية','\${(tasks.isEmpty?0:(done/tasks.length*100)).toStringAsFixed(0)}% إنجاز',Icons.bolt_rounded,const Color(0xFFEC4899),'⚡'),
          ]),
          const SizedBox(height:16),
          NCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('مهام اليوم', style: TextStyle(fontWeight: FontWeight.w800)), TextButton(onPressed: (){}, child: const Text('عرض الكل'))]),
            ...today.map((t)=>ListTile(contentPadding:EdgeInsets.zero, leading: Checkbox(value:t.status=='done', activeColor:AppColors.primary, onChanged:(v){ t.status=v!?'done':'todo'; tasksBox.put(t.id,t.toMap());}), title: Text(t.title), onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>TaskDetailScreen(task:t))))),
            if(today.isEmpty) const Padding(padding: EdgeInsets.all(12), child: Text('لا مهام اليوم ✨', style: TextStyle(color:Colors.grey))),
          ])),
          const SizedBox(height:16),
          NCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('نظرة أسبوعية', style: TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height:16),
            SizedBox(height:80, child: LineChart(LineChartData(gridData: const FlGridData(show:false), titlesData: const FlTitlesData(show:false), borderData: FlBorderData(show:false), lineBarsData:[LineChartBarData(isCurved:true, color:AppColors.primary, barWidth:3, dotData: const FlDotData(show:false), belowBarData: BarAreaData(show:true, color:AppColors.primary.withOpacity(0.15)), spots: const [FlSpot(0,1),FlSpot(1,2.5),FlSpot(2,1.8),FlSpot(3,3.2),FlSpot(4,2),FlSpot(5,3.8),FlSpot(6,3)])]))),
          ])),
        ]));
      });
    });
  }
  Widget _bento(String t,String s,IconData ic,Color c,String big){ return NCard(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children:[Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color:c.withOpacity(0.12), borderRadius: BorderRadius.circular(10)), child: Icon(ic,size:18,color:c)), const Spacer(), Text(big, style: TextStyle(fontWeight: FontWeight.w900, fontSize:18, color:c))]), const Spacer(), Text(t, style: const TextStyle(fontWeight: FontWeight.w800, fontSize:14)), const SizedBox(height:2), Text(s, style: const TextStyle(fontSize:11, color:Colors.grey)) ])); }
}
