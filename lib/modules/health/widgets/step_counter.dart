import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:life_manager_pro/core/constants/app_colors.dart';
import 'package:life_manager_pro/modules/health/providers/health_provider.dart';

class StepCounter extends ConsumerStatefulWidget {
  const StepCounter({super.key});

  @override
  ConsumerState<StepCounter> createState() => _StepCounterState();
}

class _StepCounterState extends ConsumerState<StepCounter> {
  int _steps = 0;
  final int _goal = 8000;

  @override
  void initState() {
    super.initState();
    _loadSteps();
  }

  Future<void> _loadSteps() async {
    final entry = ref.read(healthProvider);
    if (entry != null) {
      setState(() {
        _steps = entry.steps;
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
                    'Steps Today',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Flexible(
                  child: Text(
                    'Goal: 8,000',
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
                        '$_steps',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.healthColor,
                          fontSize: 24,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Text(
                        'steps taken',
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
                          value: _steps / _goal,
                          strokeWidth: 6,
                          backgroundColor: Colors.grey[200],
                          color: AppColors.healthColor,
                        ),
                        Text(
                          '${((_steps / _goal) * 100).toInt()}%',
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
                  child: ElevatedButton.icon(
                    onPressed: _addSteps,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.healthColor,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Add 100', style: TextStyle(fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _resetSteps,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.healthColor),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text('Reset', style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _addSteps() {
    setState(() {
      _steps += 100;
    });
    _saveSteps();
  }

  void _resetSteps() {
    setState(() {
      _steps = 0;
    });
    _saveSteps();
  }

  void _saveSteps() {
    final entry = ref.read(healthProvider);
    if (entry != null) {
      entry.steps = _steps;
      ref.read(healthProvider.notifier).updateEntry(entry);
    }
  }
}