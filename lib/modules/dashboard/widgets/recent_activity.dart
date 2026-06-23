// lib/modules/dashboard/widgets/recent_activity.dart
import 'package:flutter/material.dart';
import 'package:life_manager_pro/core/constants/app_colors.dart';

class RecentActivity extends StatelessWidget {
  const RecentActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final activities = [
                {'title': 'Welcome to Life Manager Pro!', 'time': 'Just now', 'icon': Icons.waving_hand},
                {'title': 'Get started by adding your first task', 'time': '1 min ago', 'icon': Icons.task},
                {'title': 'Set up your daily habits', 'time': '2 min ago', 'icon': Icons.check_circle},
              ];
              final activity = activities[index];
              
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                leading: CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: Icon(activity['icon'] as IconData, color: AppColors.primary, size: 18),
                ),
                title: Text(
                  activity['title'] as String,
                  style: const TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  activity['time'] as String,
                  style: const TextStyle(fontSize: 12),
                ),
                onTap: () {},
              );
            },
          ),
        ),
      ],
    );
  }
}