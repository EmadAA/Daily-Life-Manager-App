import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:life_manager_pro/core/constants/app_colors.dart';
import 'package:life_manager_pro/modules/habits/models/habit_model.dart';
import 'package:life_manager_pro/modules/habits/providers/habit_provider.dart';
import 'package:life_manager_pro/modules/habits/widgets/habit_card.dart';
import 'package:life_manager_pro/modules/habits/widgets/add_habit_bottom_sheet.dart';

class HabitScreen extends ConsumerStatefulWidget {
  const HabitScreen({super.key});

  @override
  ConsumerState<HabitScreen> createState() => _HabitScreenState();
}

class _HabitScreenState extends ConsumerState<HabitScreen> {
  int _currentTab = 0;
  final List<String> _tabs = ['All', 'Active', 'Completed'];

  @override
  Widget build(BuildContext context) {
    final habits = ref.watch(habitProvider);
    final filteredHabits = _getFilteredHabits(habits);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habits'),
        actions: [
          IconButton(
            icon: const Icon(Icons.show_chart),
            onPressed: () => _showStats(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: habits.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredHabits.length,
                    itemBuilder: (context, index) {
                      final habit = filteredHabits[index];
                      return HabitCard(
                        habit: habit,
                        onToggle: () => _toggleHabit(habit),
                        onDelete: () => _deleteHabit(habit.id),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddHabitBottomSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: _tabs.map((tab) {
          final index = _tabs.indexOf(tab);
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _currentTab = index),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: _currentTab == index
                          ? AppColors.habitsColor
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  tab,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _currentTab == index
                        ? AppColors.habitsColor
                        : AppColors.textSecondary,
                    fontWeight: _currentTab == index
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline, 
            size: 64, 
            color: AppColors.habitsColor.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No habits yet',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Start building good habits today!',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _showAddHabitBottomSheet(context),
            icon: const Icon(Icons.add),
            label: const Text('Create Your First Habit'),
          ),
        ],
      ),
    );
  }

  List<Habit> _getFilteredHabits(List<Habit> habits) {
    switch (_currentTab) {
      case 1:
        return habits.where((h) => h.isActive).toList();
      case 2:
        return habits.where((h) => !h.isActive).toList();
      default:
        return habits;
    }
  }

  void _toggleHabit(Habit habit) {
    ref.read(habitProvider.notifier).toggleHabit(habit);
  }

  void _deleteHabit(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Habit'),
        content: const Text('Are you sure you want to delete this habit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(habitProvider.notifier).deleteHabit(id);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAddHabitBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const AddHabitBottomSheet(),
    );
  }

  void _showStats(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Habit Statistics'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStatItem('Total Habits', '5', AppColors.habitsColor),
              _buildStatItem('Active Habits', '3', AppColors.success),
              _buildStatItem('Best Streak', '12 days', AppColors.warning),
              _buildStatItem('Completion Rate', '78%', AppColors.info),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}