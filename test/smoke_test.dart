import 'package:flutter_test/flutter_test.dart';
import 'package:nizam_os/core/models.dart';

void main() {
  test('Nizam OS task model serializes correctly', () {
    final task = Task(
      id: 'test-id',
      title: 'مهمة اختبار',
      project: 'Nizam OS',
      status: 'todo',
      done: false,
      createdAt: DateTime(2026, 1, 1),
    );

    final restored = Task.fromMap(task.toMap());

    expect(restored.id, 'test-id');
    expect(restored.title, 'مهمة اختبار');
    expect(restored.project, 'Nizam OS');
    expect(restored.done, isFalse);
  });
}
