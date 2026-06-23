import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:life_manager_pro/modules/tasks/models/task_model.dart';
import 'package:life_manager_pro/modules/health/models/health_model.dart';

class IsarDatabase {
  static Isar? _isar;

  static Future<Isar> getInstance() async {
    if (_isar != null) return _isar!;
    
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [TaskSchema, HealthEntrySchema], // Make sure both are here
      directory: dir.path,
    );
    return _isar!;
  }
}