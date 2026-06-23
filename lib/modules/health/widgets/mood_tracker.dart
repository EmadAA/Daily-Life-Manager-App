import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:life_manager_pro/core/constants/app_colors.dart';
import 'package:life_manager_pro/modules/health/models/health_model.dart';
import 'package:life_manager_pro/modules/health/providers/health_provider.dart';

class MoodTracker extends ConsumerStatefulWidget {
  const MoodTracker({super.key});

  @override
  ConsumerState<MoodTracker> createState() => _MoodTrackerState();
}

class _MoodTrackerState extends ConsumerState<MoodTracker> {
  Mood _selectedMood = Mood.neutral;
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMood();
  }

  void _loadMood() {
    final entry = ref.read(healthProvider);
    if (entry != null) {
      setState(() {
        _selectedMood = entry.mood;
        _noteController.text = entry.moodNote ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final moodData = [
      {'emoji': '😊', 'mood': Mood.happy, 'label': 'Happy'},
      {'emoji': '😐', 'mood': Mood.neutral, 'label': 'Neutral'},
      {'emoji': '😢', 'mood': Mood.sad, 'label': 'Sad'},
      {'emoji': '😡', 'mood': Mood.angry, 'label': 'Angry'},
      {'emoji': '😴', 'mood': Mood.sleepy, 'label': 'Sleepy'},
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How are you feeling?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              alignment: WrapAlignment.center,
              children: moodData.map((item) {
                final isSelected = item['mood'] == _selectedMood;
                return GestureDetector(
                  onTap: () => _selectMood(item['mood'] as Mood),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          item['emoji'] as String,
                          style: const TextStyle(fontSize: 24),
                        ),
                        Text(
                          item['label'] as String,
                          style: TextStyle(
                            fontSize: 9,
                            color: isSelected ? AppColors.primary : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                hintText: 'Add a note about your mood...',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              maxLines: 2,
              onChanged: _saveNote,
            ),
          ],
        ),
      ),
    );
  }

  void _selectMood(Mood mood) {
    setState(() {
      _selectedMood = mood;
    });
    _saveMood();
  }

  void _saveMood() {
    final entry = ref.read(healthProvider);
    if (entry != null) {
      entry.mood = _selectedMood;
      ref.read(healthProvider.notifier).updateEntry(entry);
    }
  }

  void _saveNote(String note) {
    final entry = ref.read(healthProvider);
    if (entry != null) {
      entry.moodNote = note;
      ref.read(healthProvider.notifier).updateEntry(entry);
    }
  }
}