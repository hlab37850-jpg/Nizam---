import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../core/models.dart';
import '../core/storage.dart';
import '../services/notifications.dart';

final themeProvider = StateProvider<bool>((ref) => false);

final tasksProvider = StateNotifierProvider<TasksNotifier, List<Task>>((ref) => TasksNotifier());

class TasksNotifier extends StateNotifier<List<Task>> {
  final box = Storage.box('tasks');
  final uuid = const Uuid();
  TasksNotifier() : super([]) {
    _load();
  }

  void _load() {
    state = box.values
        .map((e) => Task.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> add(String title, {String project = '', String? description}) async {
    final t = Task(
      id: uuid.v4(),
      title: title,
      project: project,
      description: description,
      createdAt: DateTime.now(),
    );
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

final transactionsProvider = StateNotifierProvider<TransactionsNotifier, List<TransactionModel>>((ref) => TransactionsNotifier());

class TransactionsNotifier extends StateNotifier<List<TransactionModel>> {
  final box = Storage.box('transactions');
  final uuid = const Uuid();
  TransactionsNotifier() : super([]) {
    _load();
  }

  void _load() {
    state = box.values
        .map((e) => TransactionModel.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> add(String title, double amount, String type, {String walletId = 'main'}) async {
    final tx = TransactionModel(
      id: uuid.v4(),
      walletId: walletId,
      title: title,
      type: type,
      amount: amount,
      date: DateTime.now(),
    );
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

final habitsProvider = StateNotifierProvider<HabitsNotifier, List<Habit>>((ref) => HabitsNotifier());

class HabitsNotifier extends StateNotifier<List<Habit>> {
  final box = Storage.box('habits');
  final uuid = const Uuid();
  HabitsNotifier() : super([]) {
    _load();
  }

  void _load() {
    state = box.values
        .map((e) => Habit.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> add(String name) async {
    final h = Habit(id: uuid.v4(), name: name, createdAt: DateTime.now());
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
    );
    await box.put(id, updated.toMap());
    _load();
  }
}

final walletsProvider = StateNotifierProvider<WalletsNotifier, List<Wallet>>((ref) => WalletsNotifier());

class WalletsNotifier extends StateNotifier<List<Wallet>> {
  final box = Storage.box('wallets');
  final uuid = const Uuid();
  WalletsNotifier() : super([]) {
    _load();
  }

  void _load() {
    if (box.isEmpty) {
      final main = Wallet(id: 'main', name: 'الرئيسية', balance: 0);
      box.put(main.id, main.toMap());
    }
    state = box.values
        .map((e) => Wallet.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> add(String name) async {
    final w = Wallet(id: uuid.v4(), name: name);
    await box.put(w.id, w.toMap());
    _load();
  }
}
