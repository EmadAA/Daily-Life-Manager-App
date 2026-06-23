import 'package:isar/isar.dart';
import 'package:life_manager_pro/data/local/database/isar_database.dart';
import 'package:life_manager_pro/modules/tasks/models/task_model.dart';

class TaskRepository {
  Future<Isar> get _db => IsarDatabase.getInstance();

  Future<List<Task>> getAllTasks() async {
    final db = await _db;
    return db.tasks.where().findAll();
  }

  Future<List<Task>> getTodayTasks() async {
    final db = await _db;
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    return db.tasks
        .filter()
        .dueDateBetween(startOfDay, endOfDay)
        .findAll();
  }

  Future<List<Task>> getTasksByStatus(TaskStatus status) async {
    final db = await _db;
    return db.tasks
        .filter()
        .statusEqualTo(status)
        .findAll();
  }

  Future<void> addTask(Task task) async {
    final db = await _db;
    await db.writeTxn(() async {
      await db.tasks.put(task);
    });
  }

  Future<void> updateTask(Task task) async {
    final db = await _db;
    await db.writeTxn(() async {
      await db.tasks.put(task);
    });
  }

  Future<void> deleteTask(int id) async {
    final db = await _db;
    await db.writeTxn(() async {
      await db.tasks.delete(id);
    });
  }

  Future<void> deleteAllTasks() async {
    final db = await _db;
    await db.writeTxn(() async {
      await db.tasks.clear();
    });
  }
}