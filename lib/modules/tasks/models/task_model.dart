import 'package:isar/isar.dart';

part 'task_model.g.dart';

enum TaskPriority { low, medium, high }
enum TaskStatus { todo, inProgress, done }
enum TaskCategory { work, personal, health, education }

@Collection()
class Task {
  Id id = Isar.autoIncrement;
  
  late String title;
  String? description;
  
  @enumerated
  late TaskPriority priority;
  
  @enumerated
  late TaskStatus status;
  
  DateTime? dueDate;
  DateTime? reminder;
  
  @enumerated
  late TaskCategory category;
  
  List<String> subtasks = [];
  bool isRecurring = false;
  String? recurrenceRule;
  DateTime createdAt = DateTime.now();
  DateTime? completedAt;
  int streakCount = 0;
}