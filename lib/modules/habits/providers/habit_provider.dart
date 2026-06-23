import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:life_manager_pro/modules/habits/models/habit_model.dart';
import 'package:life_manager_pro/data/local/repositories/habit_repository.dart';

final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  return HabitRepository();
});

class HabitNotifier extends StateNotifier<List<Habit>> {
  final HabitRepository _repository;
  
  HabitNotifier(this._repository) : super([]) {
    loadHabits();
  }

  Future<void> loadHabits() async {
    state = await _repository.getAllHabits();
  }

  Future<void> addHabit(Habit habit) async {
    await _repository.addHabit(habit);
    await loadHabits();
  }

  Future<void> updateHabit(Habit habit) async {
    await _repository.updateHabit(habit);
    await loadHabits();
  }

  Future<void> deleteHabit(int id) async {
    await _repository.deleteHabit(id);
    await loadHabits();
  }

  Future<void> toggleHabit(Habit habit) async {
    final today = DateTime(
      DateTime.now().year, 
      DateTime.now().month, 
      DateTime.now().day
    );
    
    if (habit.completedDates.contains(today)) {
      habit.completedDates.remove(today);
      habit.currentStreak = _calculateStreak(habit.completedDates);
    } else {
      habit.completedDates.add(today);
      habit.currentStreak = _calculateStreak(habit.completedDates);
      if (habit.currentStreak > habit.bestStreak) {
        habit.bestStreak = habit.currentStreak;
      }
    }
    
    await updateHabit(habit);
  }

  int _calculateStreak(List<DateTime> dates) {
    if (dates.isEmpty) return 0;
    
    final sortedDates = List<DateTime>.from(dates)..sort();
    int streak = 1;
    final today = DateTime.now();
    final lastDate = sortedDates.last;
    
    // Check if last completion is today or yesterday
    final daysDiff = today.difference(lastDate).inDays;
    if (daysDiff > 1) return 0;
    if (daysDiff == 1) streak = 1;
    
    for (int i = sortedDates.length - 1; i > 0; i--) {
      final diff = sortedDates[i].difference(sortedDates[i - 1]).inDays;
      if (diff == 1) {
        streak++;
      } else {
        break;
      }
    }
    
    return streak;
  }
}

final habitProvider = StateNotifierProvider<HabitNotifier, List<Habit>>((ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return HabitNotifier(repository);
});