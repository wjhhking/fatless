import 'package:flutter/material.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  String _selectedDuration = 'All';

  final List<String> _durationFilters = ['All', '5-10 min', '10-20 min', '20-30 min', '30+ min'];

  final List<WorkoutCard> _workouts = [
    WorkoutCard(
      title: 'Morning Yoga Flow',
      description: 'Gentle stretches to start your day',
      duration: '15 min',
      difficulty: 'Beginner',
      category: 'Yoga',
      videoUrl: 'placeholder',
    ),
    WorkoutCard(
      title: 'HIIT Cardio Blast',
      description: 'High-intensity interval training',
      duration: '20 min',
      difficulty: 'Intermediate',
      category: 'Cardio',
      videoUrl: 'placeholder',
    ),
    WorkoutCard(
      title: 'Core Strengthening',
      description: 'Build your core muscles',
      duration: '12 min',
      difficulty: 'Beginner',
      category: 'Strength',
      videoUrl: 'placeholder',
    ),
    WorkoutCard(
      title: 'Full Body Stretch',
      description: 'Relax and recover',
      duration: '25 min',
      difficulty: 'Beginner',
      category: 'Flexibility',
      videoUrl: 'placeholder',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workouts'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildDurationFilter(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredWorkouts.length,
              itemBuilder: (context, index) {
                return _buildWorkoutCard(_filteredWorkouts[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add workout feature coming soon!')),
          );
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  List<WorkoutCard> get _filteredWorkouts {
    if (_selectedDuration == 'All') return _workouts;

    return _workouts.where((workout) {
      final duration = int.parse(workout.duration.split(' ')[0]);
      switch (_selectedDuration) {
        case '5-10 min':
          return duration >= 5 && duration <= 10;
        case '10-20 min':
          return duration >= 10 && duration <= 20;
        case '20-30 min':
          return duration >= 20 && duration <= 30;
        case '30+ min':
          return duration >= 30;
        default:
          return true;
      }
    }).toList();
  }

  Widget _buildDurationFilter() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _durationFilters.length,
        itemBuilder: (context, index) {
          final filter = _durationFilters[index];
          final isSelected = _selectedDuration == filter;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedDuration = filter;
                });
              },
              selectedColor: Colors.orange.withOpacity(0.2),
              checkmarkColor: Colors.orange,
            ),
          );
        },
      ),
    );
  }

  Widget _buildWorkoutCard(WorkoutCard workout) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
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
                    Icons.play_circle_outline,
                    size: 60,
                    color: Colors.grey,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      workout.duration,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
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
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        workout.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _buildCategoryChip(workout.category),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  workout.description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildInfoChip(Icons.timer, workout.duration, Colors.blue),
                    const SizedBox(width: 8),
                    _buildInfoChip(Icons.trending_up, workout.difficulty, _getDifficultyColor(workout.difficulty)),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _showWorkoutDetails(workout);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Start Workout'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        category,
        style: const TextStyle(
          color: Colors.orange,
          fontSize: 12,
          fontWeight: FontWeight.w500,
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

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showWorkoutDetails(WorkoutCard workout) {
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
              workout.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              workout.description,
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _buildInfoChip(Icons.timer, workout.duration, Colors.blue),
                const SizedBox(width: 8),
                _buildInfoChip(Icons.trending_up, workout.difficulty, _getDifficultyColor(workout.difficulty)),
                const SizedBox(width: 8),
                _buildCategoryChip(workout.category),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Workout Steps:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('1. Warm-up (2 minutes)\n2. Main exercise routine\n3. Cool-down stretches\n4. Final relaxation'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Video player coming soon!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text('Play Video', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WorkoutCard {
  final String title;
  final String description;
  final String duration;
  final String difficulty;
  final String category;
  final String videoUrl;

  WorkoutCard({
    required this.title,
    required this.description,
    required this.duration,
    required this.difficulty,
    required this.category,
    required this.videoUrl,
  });
}
