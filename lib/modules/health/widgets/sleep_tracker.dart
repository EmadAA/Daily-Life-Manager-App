import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:life_manager_pro/core/constants/app_colors.dart';
import 'package:life_manager_pro/modules/health/providers/health_provider.dart';

class SleepTracker extends ConsumerStatefulWidget {
  const SleepTracker({super.key});

  @override
  ConsumerState<SleepTracker> createState() => _SleepTrackerState();
}

class _SleepTrackerState extends ConsumerState<SleepTracker> {
  double _sleepHours = 0;
  final double _goal = 8;

  @override
  void initState() {
    super.initState();
    _loadSleep();
  }

  void _loadSleep() {
    final entry = ref.read(healthProvider);
    if (entry != null) {
      setState(() {
        _sleepHours = entry.sleepHours;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    'Sleep Tracking',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Flexible(
                  child: Text(
                    'Goal: 8h',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_sleepHours.toStringAsFixed(1)}h',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          fontSize: 24,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Text(
                        'hours of sleep',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: _sleepHours / _goal,
                          strokeWidth: 6,
                          backgroundColor: Colors.grey[200],
                          color: AppColors.primary,
                        ),
                        Text(
                          '${((_sleepHours / _goal) * 100).toInt()}%',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _sleepHours,
                    min: 0,
                    max: 12,
                    divisions: 24,
                    label: '${_sleepHours.toStringAsFixed(1)}h',
                    onChanged: _updateSleep,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${_sleepHours.toStringAsFixed(1)}h',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _updateSleep(double value) {
    setState(() {
      _sleepHours = value;
    });
    _saveSleep();
  }

  void _saveSleep() {
    final entry = ref.read(healthProvider);
    if (entry != null) {
      entry.sleepHours = _sleepHours;
      ref.read(healthProvider.notifier).updateEntry(entry);
    }
  }
}