class Task {
  final String id;
  String title;
  String description;
  DateTime? dueDate;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.dueDate,
    this.isCompleted = false,
  });

  void complete() {
    isCompleted = true;
  }

  bool isOverdue() {
    final due = dueDate;
    if (due == null) return false;
    return DateTime.now().isAfter(due) && !isCompleted;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate?.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  @override
  String toString() {
    final status = isCompleted ? '[X]' : '[ ]';
    final due = dueDate != null ? ' (Due: ${dueDate.toString().split(' ')[0]})' : '';
    return '$status $title (ID: $id)$due';
  }
}