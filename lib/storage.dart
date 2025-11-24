import 'dart:convert';
import 'dart:io';
import 'task.dart';

class TaskStorage {
  final String filePath;

  TaskStorage(this.filePath);

  Future<void> saveTasksOrThrow(List<Task> tasks) async {
    final file = File(filePath);
    final jsonList = tasks.map((t) => t.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonList));
  }

  Future<List<Task>> loadTasksOrThrow() async {
    final file = File(filePath);
    if (!await file.exists()) {
      return [];
    }
    final content = await file.readAsString();
    final jsonList = jsonDecode(content) as List;
    return jsonList.map((json) => Task.fromJson(json)).toList();
  }

  Future<void> clearTasks() async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }
}