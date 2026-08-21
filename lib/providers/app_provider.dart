import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../core/models.dart';
import '../core/storage.dart';
import '../services/notifications.dart';

final themeProvider = StateProvider<bool>((ref) => false);

final tasksProvider =
    StateNotifierProvider<TasksNotifier, List<Task>>(
  (ref) => TasksNotifier(),
);

class TasksNotifier extends StateNotifier<List<Task>> {
  final BoxLike box = BoxLike('tasks');
  final uuid = const Uuid();

  TasksNotifier() : super([]) {
    _load();
  }

  void _load() {
    state = box.values
        .map(
          (e) => Task.fromMap(
            Map<String, dynamic>.from(e as Map),
          ),
        )
        .toList();
  }

  Future<void> add(
    String title, {
    String project = '',
  }) async {
    final task = Task(
      id: uuid.v4(),
      title: title,
      project: project,
      createdAt: DateTime.now(),
    );

    await box.put(
      task.id,
      task.toMap(),
    );

    state = [...state, task];
  }

  Future<void> toggle(Task task) async {
    final next = Task(
      id: task.id,
      title: task.title,
      project: task.project,
      status: task.done ? 'todo' : 'done',
      done: !task.done,
      createdAt: task.createdAt,
    );

    await box.put(
      task.id,
      next.toMap(),
    );

    _load();
  }

  Future<void> move(
    Task task,
    String status,
  ) async {
    final next = Task(
      id: task.id,
      title: task.title,
      project: task.project,
      status: status,
      done: status == 'done',
      createdAt: task.createdAt,
    );

    await box.put(
      task.id,
      next.toMap(),
    );

    _load();
  }

  Future<void> notify(Task task) {
    return NotificationService.show(
      'مهمة: ${task.title}',
      'حان وقت إنجاز المهمة',
    );
  }
}

/// Small abstraction to keep provider code independent
/// from Hive's concrete Box type.
class BoxLike {
  final dynamic _box;

  BoxLike(String name) : _box = Storage.box(name);

  Iterable<dynamic> get values => _box.values;

  Future<void> put(dynamic key, dynamic value) {
    return _box.put(key, value);
  }
}

final financeProvider = Provider<double>((ref) {
  final box = Storage.box('transactions');

  double total = 0;

  for (final value in box.values) {
    if (value is! Map) continue;

    final map = Map<String, dynamic>.from(value);

    final amount = map['amount'];

    if (amount is! num) continue;

    final valueAmount = amount.toDouble();

    total += map['type'] == 'income'
        ? valueAmount
        : -valueAmount;
  }

  return total;
});

final habitsProvider =
    StateProvider<Map<String, bool>>(
  (ref) => {},
);
