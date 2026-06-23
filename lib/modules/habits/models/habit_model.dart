import 'package:isar/isar.dart';

part 'habit_model.g.dart';

enum HabitFrequency { daily, weekly, custom }

@Collection()
@Name('habits')
class Habit {
  Id id = Isar.autoIncrement;
  
  late String name;
  String? description;
  
  @enumerated
  late HabitFrequency frequency;
  
  List<int> daysOfWeek = []; // 0=Monday, 6=Sunday
  DateTime createdAt = DateTime.now();
  int currentStreak = 0;
  int bestStreak = 0;
  String? category;
  bool isActive = true;
  List<DateTime> completedDates = [];
}