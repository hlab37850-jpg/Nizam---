
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../core/models.dart';
import '../core/storage.dart';
import '../services/notifications.dart';

final themeProvider = StateProvider<bool>((ref) => false);
const _uuid = Uuid();

// Tasks
final tasksProvider = StateNotifierProvider<TasksNotifier, List<Task>>((ref) => TasksNotifier());

class TasksNotifier extends StateNotifier<List<Task>> {
  final box = Storage.box('tasks');
  TasksNotifier() : super([]) { _load(); }

  void _load() {
    state = box.values.map((e) => Task.fromMap(Map<String, dynamic>.from(e as Map))).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> add(String title, {String project = '', String description = '', int priority = 0}) async {
    final t = Task(id: _uuid.v4(), title: title, project: project, description: description, priority: priority, createdAt: DateTime.now());
    await box.put(t.id, t.toMap());
    _load();
  }

  Future<void> toggle(Task t) async {
    final n = t.copyWith(status: t.done ? 'todo' : 'done', done: !t.done);
    await box.put(t.id, n.toMap());
    _load();
  }

  Future<void> move(Task t, String status) async {
    final n = t.copyWith(status: status, done: status == 'done');
    await box.put(t.id, n.toMap());
    _load();
  }

  Future<void> delete(Task t) async {
    await box.delete(t.id);
    _load();
  }

  Future<void> incPomodoro(Task t) async {
    final n = t.copyWith(pomodoroCount: t.pomodoroCount + 1);
    await box.put(t.id, n.toMap());
    _load();
  }

  Future<void> notifyTask(Task t) => NotificationService.show('مهمة: \${t.title}', 'حان وقت إنجاز المهمة');
}

// Transactions
final transactionsProvider = StateNotifierProvider<TransactionsNotifier, List<TransactionModel>>((ref) => TransactionsNotifier());

class TransactionsNotifier extends StateNotifier<List<TransactionModel>> {
  final box = Storage.box('transactions');
  TransactionsNotifier() : super([]) { _load(); }

  void _load() {
    final list = box.values.map((e) => TransactionModel.fromMap(Map<String, dynamic>.from(e as Map))).toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    state = list;
  }

  Future<void> add(String title, double amount, String type, {String walletId = 'main', String category = 'عام'}) async {
    final tx = TransactionModel(id: _uuid.v4(), walletId: walletId, title: title, type: type, category: category, amount: amount, date: DateTime.now());
    await box.put(tx.id, tx.toMap());
    _load();
  }

  Future<void> delete(String id) async {
    await box.delete(id);
    _load();
  }
}

final financeProvider = Provider<double>((ref) {
  final txs = ref.watch(transactionsProvider);
  double total = 0;
  for (final t in txs) {
    total += t.type == 'income' ? t.amount : -t.amount;
  }
  return total;
});

// Habits
final habitsProvider = StateNotifierProvider<HabitsNotifier, List<Habit>>((ref) => HabitsNotifier());

class HabitsNotifier extends StateNotifier<List<Habit>> {
  final box = Storage.box('habits');
  HabitsNotifier() : super([]) { _load(); }

  void _load() {
    state = box.values.map((e) => Habit.fromMap(Map<String, dynamic>.from(e as Map))).toList();
  }

  Future<void> add(String name) async {
    final h = Habit(id: _uuid.v4(), name: name, createdAt: DateTime.now());
    await box.put(h.id, h.toMap());
    _load();
  }

  Future<void> complete(String id) async {
    final boxItem = box.get(id);
    if (boxItem == null) return;
    final habit = Habit.fromMap(Map<String, dynamic>.from(boxItem as Map));
    final today = DateTime.now().toIso8601String().split('T')[0];
    if (habit.completedDates.contains(today)) return;
    final updated = Habit(
      id: habit.id,
      name: habit.name,
      streak: habit.streak + 1,
      createdAt: habit.createdAt,
      completedDates: [...habit.completedDates, today],
      icon: habit.icon,
    );
    await box.put(id, updated.toMap());
    _load();
  }

  Future<void> delete(String id) async {
    await box.delete(id);
    _load();
  }
}

// Wallets
final walletsProvider = StateNotifierProvider<WalletsNotifier, List<Wallet>>((ref) => WalletsNotifier());

class WalletsNotifier extends StateNotifier<List<Wallet>> {
  final box = Storage.box('wallets');
  WalletsNotifier() : super([]) { _load(); }

  void _load() {
    if (box.isEmpty) {
      final main = Wallet(id: 'main', name: 'الرئيسية', balance: 0);
      box.put(main.id, main.toMap());
    }
    state = box.values.map((e) => Wallet.fromMap(Map<String, dynamic>.from(e as Map))).toList();
  }

  Future<void> add(String name) async {
    final w = Wallet(id: _uuid.v4(), name: name);
    await box.put(w.id, w.toMap());
    _load();
  }

  Future<void> delete(String id) async {
    if (id == 'main') return;
    await box.delete(id);
    _load();
  }
}

// Budgets
final budgetsProvider = StateNotifierProvider<BudgetsNotifier, List<Budget>>((ref) => BudgetsNotifier());

class BudgetsNotifier extends StateNotifier<List<Budget>> {
  final box = Storage.box('budgets');
  BudgetsNotifier() : super([]) { _load(); }

  void _load() {
    state = box.values.map((e) => Budget.fromMap(Map<String, dynamic>.from(e as Map))).toList();
  }

  Future<void> add(String name, double limit) async {
    final b = Budget(id: _uuid.v4(), name: name, limit: limit);
    await box.put(b.id, b.toMap());
    _load();
  }

  Future<void> delete(String id) async {
    await box.delete(id);
    _load();
  }
}

// Debts
final debtsProvider = StateNotifierProvider<DebtsNotifier, List<Debt>>((ref) => DebtsNotifier());

class DebtsNotifier extends StateNotifier<List<Debt>> {
  final box = Storage.box('debts');
  DebtsNotifier() : super([]) { _load(); }

  void _load() {
    state = box.values.map((e) => Debt.fromMap(Map<String, dynamic>.from(e as Map))).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> add(String name, double amount, String type) async {
    final d = Debt(id: _uuid.v4(), name: name, amount: amount, type: type, date: DateTime.now());
    await box.put(d.id, d.toMap());
    _load();
  }

  Future<void> togglePaid(Debt d) async {
    final updated = Debt(id: d.id, name: d.name, amount: d.amount, type: d.type, date: d.date, paid: !d.paid);
    await box.put(d.id, updated.toMap());
    _load();
  }

  Future<void> delete(String id) async {
    await box.delete(id);
    _load();
  }
}

// Goals
final goalsProvider = StateNotifierProvider<GoalsNotifier, List<Goal>>((ref) => GoalsNotifier());

class GoalsNotifier extends StateNotifier<List<Goal>> {
  final box = Storage.box('goals');
  GoalsNotifier() : super([]) { _load(); }

  void _load() {
    state = box.values.map((e) => Goal.fromMap(Map<String, dynamic>.from(e as Map))).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> add(String title, {double progress = 0}) async {
    final g = Goal(id: _uuid.v4(), title: title, progress: progress, createdAt: DateTime.now());
    await box.put(g.id, g.toMap());
    _load();
  }

  Future<void> updateProgress(String id, double progress) async {
    final item = box.get(id);
    if (item == null) return;
    final g = Goal.fromMap(Map<String, dynamic>.from(item as Map));
    final updated = Goal(id: g.id, title: g.title, progress: progress.clamp(0, 1), createdAt: g.createdAt, targetDate: g.targetDate);
    await box.put(id, updated.toMap());
    _load();
  }

  Future<void> delete(String id) async {
    await box.delete(id);
    _load();
  }
}

// Journal
final journalProvider = StateNotifierProvider<JournalNotifier, List<JournalEntry>>((ref) => JournalNotifier());

class JournalNotifier extends StateNotifier<List<JournalEntry>> {
  final box = Storage.box('journal');
  JournalNotifier() : super([]) { _load(); }

  void _load() {
    state = box.values.map((e) => JournalEntry.fromMap(Map<String, dynamic>.from(e as Map))).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> add(String content, {String mood = 'neutral'}) async {
    final j = JournalEntry(id: _uuid.v4(), content: content, date: DateTime.now(), mood: mood);
    await box.put(j.id, j.toMap());
    _load();
  }

  Future<void> delete(String id) async {
    await box.delete(id);
    _load();
  }
}

// Vault - reactive wrapper
final vaultProvider = StateNotifierProvider<VaultNotifier, List<VaultItem>>((ref) => VaultNotifier());

class VaultNotifier extends StateNotifier<List<VaultItem>> {
  final box = Storage.box('vault');
  VaultNotifier() : super([]) { _load(); }

  void _load() {
    state = box.values.map((e) => VaultItem.fromMap(Map<String, dynamic>.from(e as Map))).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> refresh() async { _load(); }

  Future<void> delete(String id) async {
    await box.delete(id);
    _load();
  }
}
