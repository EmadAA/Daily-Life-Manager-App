import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:life_manager_pro/modules/health/models/health_model.dart';
import 'package:life_manager_pro/data/local/repositories/health_repository.dart';

final healthRepositoryProvider = Provider<HealthRepository>((ref) {
  return HealthRepository();
});

class HealthNotifier extends StateNotifier<HealthEntry?> {
  final HealthRepository _repository;
  
  HealthNotifier(this._repository) : super(null) {
    loadTodayEntry();
  }

  Future<void> loadTodayEntry() async {
    state = await _repository.getTodayEntry();
    if (state == null) {
      // Create a new entry for today
      state = HealthEntry()..date = DateTime.now();
    }
  }

  Future<void> saveEntry(HealthEntry entry) async {
    await _repository.addEntry(entry);
    await loadTodayEntry();
  }

  Future<void> updateEntry(HealthEntry entry) async {
    await _repository.updateEntry(entry);
    await loadTodayEntry();
  }

  Future<void> updateSteps(int steps) async {
    if (state != null) {
      state!.steps = steps;
      await updateEntry(state!);
    }
  }

  Future<void> updateWater(double water) async {
    if (state != null) {
      state!.waterIntake = water;
      await updateEntry(state!);
    }
  }

  Future<void> updateMood(Mood mood) async {
    if (state != null) {
      state!.mood = mood;
      await updateEntry(state!);
    }
  }

  Future<void> updateSleep(double hours) async {
    if (state != null) {
      state!.sleepHours = hours;
      await updateEntry(state!);
    }
  }
}

final healthProvider = StateNotifierProvider<HealthNotifier, HealthEntry?>((ref) {
  final repository = ref.watch(healthRepositoryProvider);
  return HealthNotifier(repository);
});

// For getting all entries (for charts)
final healthHistoryProvider = FutureProvider<List<HealthEntry>>((ref) async {
  final repository = ref.watch(healthRepositoryProvider);
  return await repository.getAllEntries();
});