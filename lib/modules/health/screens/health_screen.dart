import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:life_manager_pro/core/constants/app_colors.dart';
import 'package:life_manager_pro/modules/health/widgets/health_stats_cards.dart';
import 'package:life_manager_pro/modules/health/widgets/mood_tracker.dart';
import 'package:life_manager_pro/modules/health/widgets/water_tracker.dart';
import 'package:life_manager_pro/modules/health/widgets/step_counter.dart';
import 'package:life_manager_pro/modules/health/widgets/sleep_tracker.dart';

class HealthScreen extends ConsumerWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health & Wellness'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => _showHealthStats(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => _showHistory(context, ref),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const HealthStatsCards(),
            const SizedBox(height: 16),
            const StepCounter(),
            const SizedBox(height: 16),
            const WaterTracker(),
            const SizedBox(height: 16),
            const MoodTracker(),
            const SizedBox(height: 16),
            const SleepTracker(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showHealthStats(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Health Statistics'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStatItem('Average Steps', '6,240', AppColors.healthColor),
              _buildStatItem('Average Water', '1.8L', AppColors.info),
              _buildStatItem('Average Sleep', '7.5h', AppColors.primary),
              _buildStatItem('Current Mood', '😊', AppColors.warning),
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
      padding: const EdgeInsets.symmetric(vertical: 8),
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

  void _showHistory(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Health History'),
        content: const SizedBox(
          height: 200,
          child: Center(
            child: Text('Health history will be shown here with charts'),
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
}