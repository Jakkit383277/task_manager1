import 'package:test/test.dart';
import '../lib/task.dart';          // <-- แก้ไข: ใช้ ../lib/
import '../lib/task_manager.dart';  // <-- แก้ไข: ใช้ ../lib/
import '../lib/storage.dart';       // <-- แก้ไข: ใช้ ../lib/

void main() {
  group('Task Tests', () {
    test('Basic task operations', () {
      final task = Task(id: '1', title: 'Test');
      expect(task.isCompleted, false);
      task.complete();
      expect(task.isCompleted, true);
    });

    test('Null safety', () {
      final task = Task(id: '1', title: 'Test');
      expect(task.isOverdue(), false);
      task.dueDate = DateTime.now().subtract(Duration(days: 1));
      expect(task.isOverdue(), true);
    });
  });

  group('TaskManager Tests', () {
    late TaskManager manager;

    setUp(() {
      manager = TaskManager();
    });

    test('Add tasks', () {
      manager.addTask(Task(id: '1', title: 'Task 1'));
      expect(manager.allTasks.length, 1);
    });

    test('Duplicate tasks', () {
      final task = Task(id: '1', title: 'Task 1');
      expect(manager.addTask(task), true);
      expect(manager.addTask(task), false);
    });

    test('Filter tasks', () {
      manager.addTask(Task(id: '1', title: 'Task 1'));
      manager.addTask(Task(id: '2', title: 'Task 2'));
      manager.allTasks[0].complete();
      expect(manager.pendingTasks.length, 1);
      expect(manager.completedTasks.length, 1);
    });
  });

  group('Async Storage Tests', () {
    test('Save and load tasks', () async {
      final storage = TaskStorage('test_save_load.json');
      final tasks = [
        Task(id: '1', title: 'Task 1'),
        Task(id: '2', title: 'Task 2'),
      ];

      await storage.saveTasksOrThrow(tasks);
      final loaded = await storage.loadTasksOrThrow();

      expect(loaded.length, 2);
      expect(loaded[0].id, '1');

      // Clean up
      await storage.clearTasks();
    });
  });
}