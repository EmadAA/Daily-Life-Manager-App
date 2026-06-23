import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:life_manager_pro/core/app.dart';

void main() {
  runApp(
    const ProviderScope(
      child: LifeManagerApp(),
    ),
  );
}