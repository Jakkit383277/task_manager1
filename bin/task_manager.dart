import 'dart:io';
import '../lib/task.dart';
import '../lib/task_manager.dart';
import '../lib/storage.dart';

String input(String prompt) {
  stdout.write('$prompt: ');
  return stdin.readLineSync()?.trim() ?? '';
}

void main() async {
  final manager = TaskManager();
  final storage = TaskStorage('tasks.json');

  print('=== Welcome to Dart Task Manager ===');

  // Load Data
  try {
    final savedTasks = await storage.loadTasksOrThrow();
    manager.loadInitialTasks(savedTasks);
    print('Loaded ${savedTasks.length} tasks from file.');
  } catch (e) {
    print('Starting with new task list.');
  }

  while (true) {
    print('\n----------------------------------------');
    print('1. Create New Task');
    print('2. Read/View All Tasks');
    print('3. Update Task');
    print('4. Delete Task');
    print('5. Complete Task');
    print('6. Search Task by ID');
    print('7. Save Tasks');
    print('0. Exit');
    print('----------------------------------------');

    String choice = input('Enter your choice');

    switch (choice) {
      case '1': // Create
        print('\n--- Create New Task ---');
        String id = input('Enter Task ID');
        if (id.isEmpty) { print('Error: ID required.'); break; }
        
        if (manager.getTask(id) != null) {
          print('Error: ID already exists.');
          break;
        }

        String title = input('Enter Title');
        if (title.isEmpty) { print('Error: Title required.'); break; }
        
        String desc = input('Enter Description');
        
        // ใช้ addTask ธรรมดาที่คืนค่า bool
        bool success = manager.addTask(Task(id: id, title: title, description: desc));
        if (success) print('Success: Task added.');
        else print('Error: Failed to add task.');
        break;

      case '2': // Read
        print('\n--- All Tasks ---');
        if (manager.allTasks.isEmpty) print('No tasks found.');
        for (var t in manager.allTasks) {
          print(t);
        }
        break;

      case '3': // Update
        print('\n--- Update Task ---');
        String id = input('Enter Task ID');
        final task = manager.getTask(id);
        if (task == null) { print('Task not found.'); break; }
        
        String newTitle = input('New Title (current: ${task.title})');
        if (newTitle.isNotEmpty) task.title = newTitle;
        
        String newDesc = input('New Description');
        if (newDesc.isNotEmpty) task.description = newDesc;
        print('Success: Task updated.');
        break;

      case '4': // Delete
        print('\n--- Delete Task ---');
        String id = input('Enter Task ID');
        if (manager.getTask(id) != null) {
          manager.removeTask(id);
          print('Success: Task deleted.');
        } else {
          print('Task not found.');
        }
        break;

      case '5': // Complete
        print('\n--- Complete Task ---');
        String id = input('Enter Task ID');
        final task = manager.getTask(id);
        if (task != null) {
          task.complete();
          print('Success: Task completed.');
        } else {
          print('Task not found.');
        }
        break;

      case '6': // Search
        print('\n--- Search Task ---');
        String id = input('Enter Task ID');
        final task = manager.getTask(id);
        if (task != null) {
          print('Found: $task');
          print('Description: ${task.description}');
        } else {
          print('Task not found.');
        }
        break;

      case '7': // Save
        print('\nSaving...');
        try {
          // ใช้ saveTasksOrThrow ตามที่มีใน storage.dart
          await storage.saveTasksOrThrow(manager.allTasks);
          print('Success: Saved to tasks.json');
        } catch (e) {
          print('Error saving: $e');
        }
        break;

      case '0':
        print('Goodbye!');
        exit(0);

      default:
        print('Invalid choice.');
    }
  }
}