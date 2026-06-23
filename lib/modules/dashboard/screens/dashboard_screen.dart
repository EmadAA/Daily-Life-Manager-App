// lib/modules/dashboard/screens/dashboard_screen.dart
// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:life_manager_pro/core/constants/app_colors.dart';
import 'package:life_manager_pro/modules/dashboard/widgets/dashboard_header.dart';
import 'package:life_manager_pro/modules/dashboard/widgets/quick_stats_cards.dart';
import 'package:life_manager_pro/modules/dashboard/widgets/quick_actions.dart';
import 'package:life_manager_pro/modules/dashboard/widgets/recent_activity.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DashboardHeader(),
              SizedBox(height: 16),
              QuickStatsCards(),
              SizedBox(height: 24),
              QuickActions(),
              SizedBox(height: 24),
              RecentActivity(),
              SizedBox(height: 20), // Add bottom padding
            ],
          ),
        ),
      ),
    );
  }
}