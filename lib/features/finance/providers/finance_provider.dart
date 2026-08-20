
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../data/models/app_models.dart';
final walletsBoxProvider=Provider((ref)=>Hive.box('wallets'));
final transBoxProvider=Provider((ref)=>Hive.box('transactions'));
final budgetsBoxProvider=Provider((ref)=>Hive.box('budgets'));
final debtsBoxProvider=Provider((ref)=>Hive.box('debts'));
final walletsProvider=StateNotifierProvider<WalletsNotifier,List<WalletModel>>((ref)=>WalletsNotifier(ref.watch(walletsBoxProvider)));
final transProvider=StateNotifierProvider<TransNotifier,List<TransactionModel>>((ref)=>TransNotifier(ref.watch(transBoxProvider)));
final budgetsProvider=StateNotifierProvider<BudgetsNotifier,List<BudgetModel>>((ref)=>BudgetsNotifier(ref.watch(budgetsBoxProvider)));
final debtsProvider=StateNotifierProvider<DebtsNotifier,List<DebtModel>>((ref)=>DebtsNotifier(ref.watch(debtsBoxProvider)));
class WalletsNotifier extends StateNotifier<List<WalletModel>>{
  final box; WalletsNotifier(this.box): super(box.values.map((e)=>WalletModel.fromMap(Map.from(e))).toList()){ box.listenable().addListener(()=> state=box.values.map((e)=>WalletModel.fromMap(Map.from(e))).toList()); if(state.isEmpty){ final w=WalletModel.create('المحفظة الرئيسية', 0); box.put(w.id,w.toMap()); } }
  void add(WalletModel w){ box.put(w.id,w.toMap()); }
  void updateBalance(String id,double amount,String type){ final m=Map.from(box.get(id)); double bal=(m['balance'] as num).toDouble(); bal= type=='income'? bal+amount: bal-amount; m['balance']=bal; box.put(id,m); }
}
class TransNotifier extends StateNotifier<List<TransactionModel>>{
  final box; TransNotifier(this.box): super(box.values.map((e)=>TransactionModel.fromMap(Map.from(e))).toList()){ box.listenable().addListener(()=> state=box.values.map((e)=>TransactionModel.fromMap(Map.from(e))).toList()); }
  void add(TransactionModel t){ box.put(t.id,t.toMap()); }
}
class BudgetsNotifier extends StateNotifier<List<BudgetModel>>{
  final box; BudgetsNotifier(this.box): super(box.values.map((e)=>BudgetModel.fromMap(Map.from(e))).toList()){ box.listenable().addListener(()=> state=box.values.map((e)=>BudgetModel.fromMap(Map.from(e))).toList()); }
  void add(BudgetModel b){ box.put(b.id,b.toMap()); }
}
class DebtsNotifier extends StateNotifier<List<DebtModel>>{
  final box; DebtsNotifier(this.box): super(box.values.map((e)=>DebtModel.fromMap(Map.from(e))).toList()){ box.listenable().addListener(()=> state=box.values.map((e)=>DebtModel.fromMap(Map.from(e))).toList()); }
  void add(DebtModel d){ box.put(d.id,d.toMap()); }
}
