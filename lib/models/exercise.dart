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
      title: 'Morning Yoga Flow',
      description: 'Gentle stretches to start your day',
      duration: '15 min',
      difficulty: 'Beginner',
      category: 'Yoga',
      videoUrl: 'placeholder',
      caloriesBurned: 80,
      steps: [
        'Warm-up breathing (2 minutes)',
        'Sun salutation sequence (5 minutes)',
        'Standing poses (5 minutes)',
        'Cool-down stretches (3 minutes)',
      ],
      equipment: ['Yoga mat'],
    ),
    Exercise(
      title: 'HIIT Cardio Blast',
      description: 'High-intensity interval training',
      duration: '20 min',
      difficulty: 'Intermediate',
      category: 'Cardio',
      videoUrl: 'placeholder',
      caloriesBurned: 250,
      steps: [
        'Warm-up (3 minutes)',
        'High-intensity intervals (12 minutes)',
        'Active recovery (3 minutes)',
        'Cool-down (2 minutes)',
      ],
      equipment: [],
    ),
    Exercise(
      title: 'Core Strengthening',
      description: 'Build your core muscles',
      duration: '12 min',
      difficulty: 'Beginner',
      category: 'Strength',
      videoUrl: 'placeholder',
      caloriesBurned: 120,
      steps: [
        'Warm-up (2 minutes)',
        'Plank variations (4 minutes)',
        'Crunches and sit-ups (4 minutes)',
        'Stretching (2 minutes)',
      ],
      equipment: ['Exercise mat'],
    ),
    Exercise(
      title: 'Full Body Stretch',
      description: 'Relax and recover',
      duration: '25 min',
      difficulty: 'Beginner',
      category: 'Flexibility',
      videoUrl: 'placeholder',
      caloriesBurned: 60,
      steps: [
        'Gentle warm-up (5 minutes)',
        'Upper body stretches (8 minutes)',
        'Lower body stretches (8 minutes)',
        'Relaxation (4 minutes)',
      ],
      equipment: ['Yoga mat', 'Pillow'],
    ),
    Exercise(
      title: '15 Min Zumba Cardio Workout',
      description: 'Beginners Latin BurpeeGirl Short Workouts',
      duration: '15 min',
      difficulty: 'Beginner',
      category: 'Dance',
      videoUrl: 'placeholder',
      caloriesBurned: 150,
      steps: [
        'Warm-up dance moves (3 minutes)',
        'Latin dance cardio (9 minutes)',
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