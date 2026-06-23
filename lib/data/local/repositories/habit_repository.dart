import 'package:isar/isar.dart';
import 'package:life_manager_pro/data/local/database/isar_database.dart';
import 'package:life_manager_pro/modules/habits/models/habit_model.dart';

class HabitRepository {
  Future<Isar> get _db => IsarDatabase.getInstance();

  Future<List<Habit>> getAllHabits() async {
    final db = await _db;
    return db.habits.where().findAll();
  }

  Future<List<Habit>> getActiveHabits() async {
    final db = await _db;
    return db.habits.filter().isActiveEqualTo(true).findAll();
  }

  Future<void> addHabit(Habit habit) async {
    final db = await _db;
    await db.writeTxn(() async {
      await db.habits.put(habit);
    });
  }

  Future<void> updateHabit(Habit habit) async {
    final db = await _db;
    await db.writeTxn(() async {
      await db.habits.put(habit);
    });
  }

  Future<void> deleteHabit(int id) async {
    final db = await _db;
    await db.writeTxn(() async {
      await db.habits.delete(id);
    });
  }
}