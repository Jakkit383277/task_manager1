import 'task.dart';

class TaskManager {
  final List<Task> _tasks = [];

  List<Task> get allTasks => List.unmodifiable(_tasks);
  List<Task> get pendingTasks => _tasks.where((t) => !t.isCompleted).toList();
  List<Task> get completedTasks => _tasks.where((t) => t.isCompleted).toList();

  bool addTask(Task task) {
    if (_tasks.any((t) => t.id == task.id)) {
      return false;
    }
    _tasks.add(task);
    return true;
  }

  void removeTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
  }

  Task? getTask(String id) {
    try {
      return _tasks.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }

  void loadInitialTasks(List<Task> tasks) {
    _tasks.clear();
    for (var task in tasks) {
      addTask(task);
    }
  }
}