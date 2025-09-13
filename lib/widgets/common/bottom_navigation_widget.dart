import 'package:flutter/material.dart';

class BottomNavigationWidget extends StatelessWidget {
  final String currentRoute;
  
  const BottomNavigationWidget({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70, // Reduced from 100 to 70
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD), // Light blue background
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
          context,
          Icons.home,
          'Home',
          '/home',
          currentRoute == '/home',
        ),
          _buildNavItem(
            context,
            Icons.restaurant,
            'Meal',
            '/meal',
            currentRoute == '/meal',
          ),
          _buildNavItem(
            context,
            Icons.fitness_center,
            'Workout',
            '/workout',
            currentRoute == '/workout',
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String label,
    String route,
    bool isSelected,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (route != currentRoute) {
            Navigator.pushReplacementNamed(context, route);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8), // Reduced padding
          decoration: BoxDecoration(
            color: isSelected ? Colors.grey.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 28, // Slightly smaller
                height: 28,
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        icon,
                        color: isSelected ? const Color(0xFF4A90E2) : Colors.grey,
                        size: 22, // Slightly smaller
                      ),
                    ),
                    if (label == 'Home')
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                          child: const Center(
                            child: Text(
                              '6',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 2), // Reduced spacing
              Text(
                label,
                style: TextStyle(
                  fontSize: 11, // Slightly smaller
                  color: isSelected ? const Color(0xFF4A90E2) : Colors.grey,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}