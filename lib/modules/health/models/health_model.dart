import 'package:isar/isar.dart';

part 'health_model.g.dart';

enum Mood { happy, neutral, sad, angry, sleepy }

@Embedded()
class Exercise {
  String type = '';
  int duration = 0; // in minutes
  int calories = 0;
}

@Embedded()
class Medication {
  String name = '';
  String dosage = '';
  DateTime? reminderTime;
}

@Collection()
@Name('health_entries')
class HealthEntry {
  Id id = Isar.autoIncrement;
  DateTime date = DateTime.now();
  int steps = 0;
  double waterIntake = 0; // in ml
  double sleepHours = 0;
  
  @enumerated
  Mood mood = Mood.neutral;
  
  String? moodNote;
  List<Exercise> exercises = [];
  double? weight;
  String? healthNotes;
  List<Medication> medications = [];
}