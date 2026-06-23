import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:life_manager_pro/core/constants/app_colors.dart';
import 'package:life_manager_pro/modules/health/providers/health_provider.dart';

class WaterTracker extends ConsumerStatefulWidget {
  const WaterTracker({super.key});

  @override
  ConsumerState<WaterTracker> createState() => _WaterTrackerState();
}

class _WaterTrackerState extends ConsumerState<WaterTracker> {
  int _glasses = 0;
  final int _targetGlasses = 8;
  final double _glassSize = 0.25;

  @override
  void initState() {
    super.initState();
    _loadWater();
  }

  void _loadWater() {
    final entry = ref.read(healthProvider);
    if (entry != null) {
      setState(() {
        _glasses = (entry.waterIntake / _glassSize).round();
        if (_glasses > _targetGlasses) _glasses = _targetGlasses;
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
                    'Water Intake',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Flexible(
                  child: Text(
                    'Goal: 2.5L',
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
                  child: Text(
                    '${(_glasses * _glassSize).toStringAsFixed(1)}L',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.info,
                      fontSize: 24,
                    ),
                    overflow: TextOverflow.ellipsis,
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
                          value: _glasses / _targetGlasses,
                          strokeWidth: 6,
                          backgroundColor: Colors.grey[200],
                          color: AppColors.info,
                        ),
                        Text(
                          '${((_glasses / _targetGlasses) * 100).toInt()}%',
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
            Wrap(
              spacing: 6,
              runSpacing: 6,
              alignment: WrapAlignment.center,
              children: List.generate(8, (index) {
                return GestureDetector(
                  onTap: () => _toggleGlass(index),
                  child: Container(
                    width: 28,
                    height: 40,
                    decoration: BoxDecoration(
                      color: index < _glasses
                          ? AppColors.info
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: index < _glasses
                            ? AppColors.info
                            : Colors.grey[300]!,
                      ),
                    ),
                    child: Icon(
                      Icons.water_drop,
                      color: index < _glasses
                          ? Colors.white
                          : Colors.grey[400],
                      size: 16,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 12),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: _addGlass,
                    icon: const Icon(Icons.add_circle, color: AppColors.info, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$_glasses / $_targetGlasses glasses',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _removeGlass,
                    icon: const Icon(Icons.remove_circle, color: AppColors.info, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleGlass(int index) {
    setState(() {
      if (index < _glasses) {
        _glasses = index;
      } else {
        _glasses = index + 1;
      }
    });
    _saveWater();
  }

  void _addGlass() {
    setState(() {
      if (_glasses < _targetGlasses) {
        _glasses++;
      }
    });
    _saveWater();
  }

  void _removeGlass() {
    setState(() {
      if (_glasses > 0) {
        _glasses--;
      }
    });
    _saveWater();
  }

  void _saveWater() {
    final entry = ref.read(healthProvider);
    if (entry != null) {
      entry.waterIntake = _glasses * _glassSize;
      ref.read(healthProvider.notifier).updateEntry(entry);
    }
  }
}