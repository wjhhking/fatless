import 'package:flutter/material.dart';

class Exercise {
  final String title;
  final String description;
  final String duration;
  final String difficulty;
  final String category;
  final String videoUrl;
  final List<String> steps;
  final String imagePath;
  final int caloriesBurned;
  final List<String> equipment;
  final String author;
  final String views;
  final String uploadTime;
  final Color backgroundColor;

  Exercise({
    required this.title,
    required this.description,
    required this.duration,
    required this.difficulty,
    required this.category,
    required this.videoUrl,
    this.steps = const [],
    this.imagePath = '',
    this.caloriesBurned = 0,
    this.equipment = const [],
    this.author = '',
    this.views = '',
    this.uploadTime = '',
    this.backgroundColor = const Color(0xFFE3F2FD),
  });

  // Get duration as integer for calculations
  int get durationAsInt {
    return int.tryParse(duration.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
  }

  // Get formatted steps as string
  String get formattedSteps {
    if (steps.isEmpty) {
      return '1. Warm-up (2 minutes)\n2. Main exercise routine\n3. Cool-down stretches\n4. Final relaxation';
    }
    return steps.asMap().entries.map((entry) => '${entry.key + 1}. ${entry.value}').join('\n');
  }

  // Get equipment list as formatted string
  String get formattedEquipment {
    if (equipment.isEmpty) return 'No equipment needed';
    return equipment.join(', ');
  }
}

// Predefined exercise data
class ExerciseData {
  static final List<Exercise> popularExercises = [
    Exercise(
      title: '15 MIN OLDIES DANCE WORKOUT - burn calories to',
      description: 'Pamela Reif',
      duration: '14:05',
      difficulty: 'Beginner',
      category: 'Dance',
      videoUrl: 'placeholder',
      caloriesBurned: 150,
      imagePath: 'assets/images/exercise/diet_dance.png',
      author: 'Pamela Reif ✓',
      views: '9.2M views',
      uploadTime: '5 years ago',
      backgroundColor: Color(0xFFE8F5E8),
      steps: [
        'Warm-up dance moves (3 minutes)',
        'Oldies dance routine (9 minutes)',
        'Cool-down stretches (3 minutes)',
      ],
      equipment: [],
    ),
    Exercise(
      title: '[15min Diet Dance] Can\'t Stop The Feeling I Say So | My Styl.',
      description: 'JINIDANCE_official',
      duration: '18:29',
      difficulty: 'Beginner',
      category: 'Dance',
      videoUrl: 'placeholder',
      caloriesBurned: 180,
      imagePath: 'assets/images/exercise/diet_dance.png',
      author: 'JINIDANCE_official',
      views: '646K views',
      uploadTime: '5 months ago',
      backgroundColor: Color(0xFFFFE8E8),
      steps: [
        'Warm-up (2 minutes)',
        'Diet dance routine (14 minutes)',
        'Cool-down (2 minutes)',
      ],
      equipment: [],
    ),
    Exercise(
      title: '12 MIN BLACKPINK DANCE PARTY WORKOUT - Full body',
      description: 'MiZi',
      duration: '12:38',
      difficulty: 'Intermediate',
      category: 'Dance',
      videoUrl: 'placeholder',
      caloriesBurned: 140,
      imagePath: 'assets/images/exercise/black_pink.png',
      author: 'MiZi ✓',
      views: '913K views',
      uploadTime: '4 weeks ago',
      backgroundColor: Color(0xFFFFF0E6),
      steps: [
        'Warm-up (2 minutes)',
        'BLACKPINK dance workout (8 minutes)',
        'Cool-down (2 minutes)',
      ],
      equipment: [],
    ),
    Exercise(
      title: '🔥15 Min Zumba Cardio Workout🔥Beginners Latin',
      description: 'BurpeeGirl Short Workouts',
      duration: '21:24',
      difficulty: 'Beginner',
      category: 'Dance',
      videoUrl: 'placeholder',
      caloriesBurned: 200,
      imagePath: 'assets/images/exercise/zumba.png',
      author: 'BurpeeGirl Short Workouts ✓',
      views: '2.9M views',
      uploadTime: '1 year ago',
      backgroundColor: Color(0xFFE8E8FF),
      steps: [
        'Warm-up dance moves (3 minutes)',
        'Latin Zumba cardio (15 minutes)',
        'Cool-down stretches (3 minutes)',
      ],
      equipment: [],
    ),
  ];

  static Exercise? getExerciseByTitle(String title) {
    try {
      return popularExercises.firstWhere((exercise) => exercise.title == title);
    } catch (e) {
      return null;
    }
  }

  static List<Exercise> getExercisesByCategory(String category) {
    return popularExercises.where((exercise) => exercise.category.toLowerCase() == category.toLowerCase()).toList();
  }

  static List<Exercise> getExercisesByDifficulty(String difficulty) {
    return popularExercises.where((exercise) => exercise.difficulty.toLowerCase() == difficulty.toLowerCase()).toList();
  }
}