import 'package:flutter/material.dart';

class MealScreen extends StatefulWidget {
  const MealScreen({super.key});

  @override
  State<MealScreen> createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> {
  bool _blueFilterEnabled = false;

  final List<MealCard> _meals = [
    MealCard(
      title: 'Grilled Chicken Salad',
      description: 'Fresh greens with lean protein',
      calories: '320 cal',
      prepTime: '15 min',
      imageUrl: 'placeholder',
    ),
    MealCard(
      title: 'Quinoa Buddha Bowl',
      description: 'Nutritious bowl with vegetables',
      calories: '280 cal',
      prepTime: '20 min',
      imageUrl: 'placeholder',
    ),
    MealCard(
      title: 'Salmon with Vegetables',
      description: 'Omega-3 rich fish with steamed veggies',
      calories: '350 cal',
      prepTime: '25 min',
      imageUrl: 'placeholder',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Plans'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _blueFilterEnabled = !_blueFilterEnabled;
              });
            },
            icon: Icon(
              _blueFilterEnabled ? Icons.filter_alt : Icons.filter_alt_outlined,
              color: _blueFilterEnabled ? Colors.lightBlue : Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_blueFilterEnabled)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.blue[100],
              child: const Row(
                children: [
                  Icon(Icons.info, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    'Blue filter active - reduces appetite',
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _meals.length,
              itemBuilder: (context, index) {
                return _buildMealCard(_meals[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add new meal functionality
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add meal feature coming soon!')),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildMealCard(MealCard meal) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: _blueFilterEnabled ? Colors.blue.withOpacity(0.1) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Icon(
                      Icons.restaurant,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                  if (_blueFilterEnabled)
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.3),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    meal.description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildInfoChip(Icons.local_fire_department, meal.calories, Colors.orange),
                      const SizedBox(width: 8),
                      _buildInfoChip(Icons.access_time, meal.prepTime, Colors.blue),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _showRecipeDetails(meal);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('View Recipe'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  void _showRecipeDetails(MealCard meal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              meal.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              meal.description,
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Ingredients:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('• Placeholder ingredient 1\n• Placeholder ingredient 2\n• Placeholder ingredient 3'),
            const SizedBox(height: 20),
            const Text(
              'Instructions:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('1. Placeholder instruction 1\n2. Placeholder instruction 2\n3. Placeholder instruction 3'),
          ],
        ),
      ),
    );
  }
}

class MealCard {
  final String title;
  final String description;
  final String calories;
  final String prepTime;
  final String imageUrl;

  MealCard({
    required this.title,
    required this.description,
    required this.calories,
    required this.prepTime,
    required this.imageUrl,
  });
}
