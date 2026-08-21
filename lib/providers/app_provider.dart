import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../core/models.dart';
import '../core/storage.dart';

final themeProvider = StateProvider<bool>((ref) {
  return Storage.box('settings').get('darkMode', defaultValue: false) == true;
});

final tasksProvider = StateNotifierProvider<TasksNotifier, List<Task>>(
  (ref) => TasksNotifier(),
);

class TasksNotifier extends StateNotifier<List<Task>> {
  TasksNotifier() : super([]) {
    _load();
  }

  void _load() {
    final box = Storage.box('tasks');
    state = box.values
        .whereType<Map>()
        .map((e) => Task.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> add(String title, {String project = ''}) async {
    final task = Task(
      id: const Uuid().v4(),
      title: title,
      project: project,
      createdAt: DateTime.now(),
    );
    await Storage.box('tasks').put(task.id, task.toMap());
    _load();
  }

  Future<void> toggle(Task task) async {
    final updated = Task(
      id: task.id,
      title: task.title,
      project: task.project,
      status: task.done ? 'todo' : 'done',
      done: !task.done,
      createdAt: task.createdAt,
    );
    await Storage.box('tasks').put(updated.id, updated.toMap());
    _load();
  }

  Future<void> move(Task task, String status) async {
    final updated = Task(
      id: task.id,
      title: task.title,
      project: task.project,
      status: status,
      done: status == 'done',
      createdAt: task.createdAt,
    );
    await Storage.box('tasks').put(updated.id, updated.toMap());
    _load();
  }
}

final financeProvider = Provider<double>((ref) {
  var total = 0.0;
  for (final value in Storage.box('transactions').values) {
    if (value is! Map) continue;
    final map = Map<String, dynamic>.from(value);
    final amount = (map['amount'] as num?)?.toDouble() ?? 0;
    total += map['type'] == 'income' ? amount : -amount;
  }
  return total;
});
