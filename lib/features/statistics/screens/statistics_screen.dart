
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/widgets/n_card.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/app_models.dart';
class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});
  @override Widget build(BuildContext context){
    final tasks=Hive.box('tasks').values.map((e)=>TaskModel.fromMap(Map.from(e))).toList();
    final trans=Hive.box('transactions').values.map((e)=>TransactionModel.fromMap(Map.from(e))).toList();
    final habits=Hive.box('habits').values.map((e)=>HabitModel.fromMap(Map.from(e))).toList();
    final done=tasks.where((t)=>t.status=='done').length;
    final totalTasks=tasks.length;
    final income=trans.where((t)=>t.type=='income').fold(0.0,(a,b)=>a+b.amount);
    final expense=trans.where((t)=>t.type=='expense').fold(0.0,(a,b)=>a+b.amount);
    return Scaffold(appBar: AppBar(title: const Text('الإحصائيات الشاملة')), body: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(16,8,16,32), child: Column(children:[
      Row(children:[Expanded(child: NCard(color:AppColors.primary, child: Column(children:[const Icon(Icons.check_circle, color:Colors.white), const SizedBox(height:8), Text('\$done/\$totalTasks', style: const TextStyle(color:Colors.white, fontWeight: FontWeight.w900, fontSize:20)), const Text('مهام منجزة', style: TextStyle(color:Colors.white70, fontSize:12))]))), const SizedBox(width:12), Expanded(child: NCard(color:AppColors.secondary, child: Column(children:[const Icon(Icons.repeat, color:Colors.white), const SizedBox(height:8), Text('\${habits.fold(0,(a,b)=>a+b.streak)} 🔥', style: const TextStyle(color:Colors.white, fontWeight: FontWeight.w900, fontSize:20)), const Text('مجموع الستريك', style: TextStyle(color:Colors.white70, fontSize:12))])))]),
      const SizedBox(height:12),
      NCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
        const Text('الإنتاجية الأسبوعية', style: TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height:16),
        SizedBox(height:120, child: BarChart(BarChartData(barGroups: List.generate(7, (i)=> BarChartGroupData(x:i, barRods:[BarChartRodData(toY: (i%3+1)*2.0 + (totalTasks>0? done/totalTasks*3:0), color:AppColors.primary, width:12, borderRadius: BorderRadius.circular(6))])), borderData: FlBorderData(show:false), gridData: const FlGridData(show:false), titlesData: const FlTitlesData(show:false)))),
      ])),
      const SizedBox(height:12),
      NCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
        const Text('المالية', style: TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height:12),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children:[Text('الدخل: \${income.toStringAsFixed(0)}'), Text('المصروف: \${expense.toStringAsFixed(0)}')]),
        const SizedBox(height:12),
        SizedBox(height:160, child: PieChart(PieChartData(sections:[PieChartSectionData(value:income==0?1:income, title:'دخل\n\${income.toStringAsFixed(0)}', color:AppColors.secondary, radius:60), PieChartSectionData(value:expense==0?1:expense, title:'مصروف\n\${expense.toStringAsFixed(0)}', color:AppColors.warning, radius:60)]))),
      ])),
    ])));
  }
}
