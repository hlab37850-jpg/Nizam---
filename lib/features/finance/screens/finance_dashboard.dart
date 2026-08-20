
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/widgets/n_card.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/finance_provider.dart';
import 'wallets_screen.dart';
import 'budgets_screen.dart';
import 'debts_screen.dart';
class FinanceDashboard extends ConsumerWidget {
  const FinanceDashboard({super.key});
  @override Widget build(BuildContext context, WidgetRef ref){
    final wallets=ref.watch(walletsProvider);
    final trans=ref.watch(transProvider);
    final total=wallets.fold(0.0,(a,b)=>a+b.balance);
    final income=trans.where((t)=>t.type=='income').fold(0.0,(a,b)=>a+b.amount);
    final expense=trans.where((t)=>t.type=='expense').fold(0.0,(a,b)=>a+b.amount);
    final cats={}; for(var t in trans){ cats[t.category]=(cats[t.category]??0)+t.amount; }
    return SingleChildScrollView(padding: const EdgeInsets.fromLTRB(16,8,16,100), child: Column(children: [
      NCard(color: AppColors.primary, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('الرصيد الإجمالي', style: TextStyle(color:Colors.white70)), const SizedBox(height:8),
        Text('\${total.toStringAsFixed(2)} ر.س', style: const TextStyle(color:Colors.white, fontSize:32, fontWeight: FontWeight.w900)),
        const SizedBox(height:16),
        Row(children: [
          Expanded(child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(12)), child: Column(children:[const Icon(Icons.arrow_upward_rounded, color:Colors.white), Text('\${income.toStringAsFixed(0)}', style: const TextStyle(color:Colors.white, fontWeight: FontWeight.w800)), const Text('دخل', style: TextStyle(color:Colors.white70, fontSize:12))]))),
          const SizedBox(width:12),
          Expanded(child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(12)), child: Column(children:[const Icon(Icons.arrow_downward_rounded, color:Colors.white), Text('\${expense.toStringAsFixed(0)}', style: const TextStyle(color:Colors.white, fontWeight: FontWeight.w800)), const Text('مصروف', style: TextStyle(color:Colors.white70, fontSize:12))]))),
        ]),
      ])),
      const SizedBox(height:12),
      Row(children: [
        Expanded(child: NCard(onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const WalletsScreen())), child: Column(children:[const Icon(Icons.account_balance_wallet_rounded, color:AppColors.primary), const SizedBox(height:8), Text('\${wallets.length} محافظ'), const Text('إدارة المحافظ', style: TextStyle(fontSize:11, color:Colors.grey))]))),
        const SizedBox(width:12),
        Expanded(child: NCard(onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const BudgetsScreen())), child: Column(children:[const Icon(Icons.pie_chart_rounded, color:AppColors.warning), const SizedBox(height:8), const Text('الميزانيات'), const Text('تتبع الإنفاق', style: TextStyle(fontSize:11, color:Colors.grey))]))),
        const SizedBox(width:12),
        Expanded(child: NCard(onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const DebtsScreen())), child: Column(children:[const Icon(Icons.handshake_rounded, color:AppColors.secondary), const SizedBox(height:8), const Text('الديون'), const Text('لمن لك وعليك', style: TextStyle(fontSize:11, color:Colors.grey))]))),
      ]),
      const SizedBox(height:16),
      if(trans.isNotEmpty) NCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('توزيع المصاريف', style: TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height:16),
        SizedBox(height:180, child: PieChart(PieChartData(sections: cats.entries.take(5).map((e){ final colors=[AppColors.primary, AppColors.secondary, AppColors.warning, const Color(0xFFEC4899), const Color(0xFF06B6D4)]; final idx=cats.keys.toList().indexOf(e.key)%colors.length; return PieChartSectionData(value:(e.value as double), title:'\${e.key}\n\${(e.value as double).toStringAsFixed(0)}', color:colors[idx], radius:60, titleStyle: const TextStyle(fontSize:11, fontWeight: FontWeight.w700, color:Colors.white)); }).toList()))),
      ])),
      const SizedBox(height:16),
      NCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children:[const Text('آخر العمليات', style: TextStyle(fontWeight: FontWeight.w800)), TextButton(onPressed: ()=>_addTrans(context, ref), child: const Text('إضافة'))]),
        ...trans.reversed.take(8).map((t)=> ListTile(leading: CircleAvatar(backgroundColor: t.type=='income'? AppColors.secondary.withOpacity(0.15): AppColors.warning.withOpacity(0.15), child: Icon(t.type=='income'? Icons.arrow_upward: Icons.arrow_downward, size:18, color: t.type=='income'? AppColors.secondary: AppColors.warning)), title: Text(t.category, style: const TextStyle(fontWeight: FontWeight.w700)), subtitle: Text(t.date.toString().split(' ')[0], style: const TextStyle(fontSize:11)), trailing: Text('\${t.type=='income'?'+':''}\${t.amount.toStringAsFixed(0)}', style: TextStyle(fontWeight: FontWeight.w800, color: t.type=='income'? AppColors.secondary: Colors.red)))),
        if(trans.isEmpty) const Padding(padding: EdgeInsets.all(16), child: Center(child: Text('لا يوجد عمليات بعد'))),
      ])),
    ]));
  }
  void _addTrans(BuildContext ctx, WidgetRef ref){
    final amountCtrl=TextEditingController(); String type='expense'; String cat='طعام'; String? walletId=ref.read(walletsProvider).isEmpty? null: ref.read(walletsProvider).first.id;
    showModalBottomSheet(context: ctx, isScrollControlled:true, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))), builder: (_)=> Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left:16, right:16, top:16), child: Column(mainAxisSize: MainAxisSize.min, children:[
      const Text('عملية جديدة', style: TextStyle(fontWeight: FontWeight.w800, fontSize:18)), const SizedBox(height:16),
      TextField(controller: amountCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText:'المبلغ', border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))))),
      const SizedBox(height:12),
      DropdownButtonFormField<String>(value:type, items: const [DropdownMenuItem(value:'income', child: Text('دخل')), DropdownMenuItem(value:'expense', child: Text('مصروف'))], onChanged:(v)=>type=v!, decoration: const InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))))),
      const SizedBox(height:12),
      TextField(onChanged:(v)=>cat=v, decoration: const InputDecoration(labelText:'التصنيف (طعام، مواصلات...)', border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))))),
      const SizedBox(height:16),
      SizedBox(width:double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor:Colors.white, padding: const EdgeInsets.symmetric(vertical:14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), onPressed: (){
        final amt=double.tryParse(amountCtrl.text)??0; if(amt<=0|| walletId==null) return;
        final t=TransactionModel.create(walletId:walletId!, amount:amt, type:type, cat:cat);
        ref.read(transProvider.notifier).add(t);
        ref.read(walletsProvider.notifier).updateBalance(walletId!, amt, type);
        Navigator.pop(ctx);
      }, child: const Text('حفظ'))),
      const SizedBox(height:24),
    ])));
  }
}
