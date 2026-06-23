import 'package:isar/isar.dart';
import 'package:life_manager_pro/data/local/database/isar_database.dart';
import 'package:life_manager_pro/modules/health/models/health_model.dart';

class HealthRepository {
  Future<Isar> get _db => IsarDatabase.getInstance();

  Future<List<HealthEntry>> getAllEntries() async {
    try {
      final db = await _db;
      // Use a different query approach
      final entries = await db.collection<HealthEntry>().where().findAll();
      return entries.toList();
    } catch (e) {
      print('Error getting health entries: $e');
      return [];
    }
  }

  Future<HealthEntry?> getTodayEntry() async {
    try {
      final db = await _db;
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final entries = await db
          .collection<HealthEntry>()
          .filter()
          .dateBetween(startOfDay, endOfDay)
          .findAll();

      return entries.isEmpty ? null : entries.first;
    } catch (e) {
      print('Error getting today entry: $e');
      return null;
    }
  }

  Future<void> addEntry(HealthEntry entry) async {
    try {
      final db = await _db;
      await db.writeTxn(() async {
        await db.collection<HealthEntry>().put(entry);
      });
    } catch (e) {
      print('Error adding health entry: $e');
      rethrow;
    }
  }

  Future<void> updateEntry(HealthEntry entry) async {
    try {
      final db = await _db;
      await db.writeTxn(() async {
        await db.collection<HealthEntry>().put(entry);
      });
    } catch (e) {
      print('Error updating health entry: $e');
      rethrow;
    }
  }

  Future<void> deleteEntry(int id) async {
    try {
      final db = await _db;
      await db.writeTxn(() async {
        await db.collection<HealthEntry>().delete(id);
      });
    } catch (e) {
      print('Error deleting health entry: $e');
      rethrow;
    }
  }

  Future<List<HealthEntry>> getEntriesForDateRange(
      DateTime start, DateTime end) async {
    try {
      final db = await _db;
      final entries = await db
          .collection<HealthEntry>()
          .filter()
          .dateBetween(start, end)
          .findAll();
      return entries.toList();
    } catch (e) {
      print('Error getting entries for range: $e');
      return [];
    }
  }
}
