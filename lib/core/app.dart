// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:life_manager_pro/core/constants/app_colors.dart';
import 'package:life_manager_pro/core/constants/app_strings.dart';
import 'package:life_manager_pro/core/navigation/app_navigation.dart';
import 'package:life_manager_pro/core/themes/light_theme.dart';
import 'package:life_manager_pro/core/themes/dark_theme.dart';
import 'package:life_manager_pro/core/providers/theme_provider.dart';

class LifeManagerApp extends ConsumerWidget {
  const LifeManagerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);
    
    return MaterialApp(
      title: AppStrings.appName,
      theme: isDarkMode ? darkTheme : lightTheme,
      darkTheme: darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: const AppNavigation(),
    );
  }
}