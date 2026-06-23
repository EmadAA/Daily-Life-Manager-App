// lib/modules/dashboard/widgets/quick_actions.dart
import 'package:flutter/material.dart';
import 'package:life_manager_pro/core/constants/app_colors.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildActionButton(
              context,
              icon: Icons.add_task,
              label: 'New Task',
              color: AppColors.tasksColor,
              onTap: () => _showComingSoon(context),
            ),
            const SizedBox(width: 8),
            _buildActionButton(
              context,
              icon: Icons.favorite,
              label: 'Log Health',
              color: AppColors.healthColor,
              onTap: () => _showComingSoon(context),
            ),
            const SizedBox(width: 8),
            _buildActionButton(
              context,
              icon: Icons.edit_note,
              label: 'New Note',
              color: AppColors.journalColor,
              onTap: () => _showComingSoon(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('This feature is coming soon! 🚀'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}