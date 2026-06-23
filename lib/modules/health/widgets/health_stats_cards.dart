import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:life_manager_pro/core/constants/app_colors.dart';
import 'package:life_manager_pro/modules/health/models/health_model.dart';
import 'package:life_manager_pro/modules/health/providers/health_provider.dart';

class HealthStatsCards extends ConsumerWidget {
  const HealthStatsCards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthEntry = ref.watch(healthProvider);
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        final stats = [
          {
            'title': 'Steps',
            'value': healthEntry?.steps.toString() ?? '0',
            'icon': Icons.directions_walk,
            'color': AppColors.healthColor,
            'goal': '8,000',
          },
          {
            'title': 'Water',
            'value': '${healthEntry?.waterIntake ?? 0}L',
            'icon': Icons.water_drop,
            'color': AppColors.info,
            'goal': '2.5L',
          },
          {
            'title': 'Sleep',
            'value': '${healthEntry?.sleepHours ?? 0}h',
            'icon': Icons.nightlife,
            'color': AppColors.primary,
            'goal': '8h',
          },
          {
            'title': 'Mood',
            'value': _getMoodEmoji(healthEntry?.mood ?? Mood.neutral),
            'icon': Icons.mood,
            'color': AppColors.warning,
            'goal': 'Happy',
          },
        ];
        final stat = stats[index];
        return _HealthStatCard(
          title: stat['title'] as String,
          value: stat['value'] as String,
          icon: stat['icon'] as IconData,
          color: stat['color'] as Color,
          goal: stat['goal'] as String,
        );
      },
    );
  }

  String _getMoodEmoji(Mood mood) {
    switch (mood) {
      case Mood.happy: return '😊';
      case Mood.neutral: return '😐';
      case Mood.sad: return '😢';
      case Mood.angry: return '😡';
      case Mood.sleepy: return '😴';
    }
  }
}

class _HealthStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String goal;

  const _HealthStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(icon, color: color, size: 16),
                ),
                Flexible(
                  child: Text(
                    'Goal: $goal',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 9,
                      color: AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Flexible(
              child: Text(
                value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 18,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}