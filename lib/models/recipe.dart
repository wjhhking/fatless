class Recipe {
  final String title;
  final String ingredients;
  final String calories;
  final String time;
  final String imagePath;
  final String description;
  final List<String> nutritionInfo;
  final String difficulty;
  final String category;

  Recipe({
    required this.title,
    required this.ingredients,
    required this.calories,
    required this.time,
    required this.imagePath,
    required this.description,
    this.nutritionInfo = const [],
    this.difficulty = 'Easy',
    this.category = 'Main Course',
  });

  // Convert nutrition info to formatted string
  String get formattedNutrition {
    if (nutritionInfo.isEmpty) return '';
    return nutritionInfo.join('\n');
  }

  // Get calories as integer for calculations
  int get caloriesAsInt {
    return int.tryParse(calories.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
  }

  // Get time as integer for calculations
  int get timeAsInt {
    return int.tryParse(time.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
  }
}

// Predefined recipe data
class RecipeData {
  static final List<Recipe> popularRecipes = [
    Recipe(
      title: 'Bell Pepper Beef Burger',
      ingredients: 'Bell Pepper + Lettuce + Beef\n+ Yogurt Sauce + Tomato',
      calories: '470 Kcal',
      time: '10 min',
      imagePath: 'assets/images/bell_pepper_burger.png',
      description: 'A delicious and healthy burger alternative using bell peppers as the bun.',
      nutritionInfo: [
        'Protein: ~28g',
        'Carbs: ~16g',
        'Fat: ~13g',
      ],
      difficulty: 'Easy',
      category: 'Main Course',
    ),
    Recipe(
      title: 'Lettuce Wrap Burger',
      ingredients: 'Lettuce + Egg + Low-fat',
      calories: '280 Kcal',
      time: '8 min',
      imagePath: 'assets/images/lettuce_burger_Small.png',
      description: 'A light and refreshing burger wrapped in crisp lettuce leaves.',
      nutritionInfo: [
        'Protein: ~20g',
        'Carbs: ~8g',
        'Fat: ~8g',
      ],
      difficulty: 'Easy',
      category: 'Light Meal',
    ),
  ];

  static Recipe? getRecipeByTitle(String title) {
    try {
      return popularRecipes.firstWhere((recipe) => recipe.title == title);
    } catch (e) {
      return null;
    }
  }
}