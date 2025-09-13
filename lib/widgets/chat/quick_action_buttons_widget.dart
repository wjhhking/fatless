import 'package:flutter/material.dart';

class QuickActionButtonsWidget extends StatelessWidget {
  final Function(String) onQuickAction;

  const QuickActionButtonsWidget({
    super.key,
    required this.onQuickAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildQuickActionButton(
            'Distract me',
            Icons.games,
            Colors.purple,
            () => onQuickAction('distract'),
          ),
          _buildQuickActionButton(
            'Motivate me',
            Icons.fitness_center,
            Colors.orange,
            () => onQuickAction('motivate'),
          ),
          _buildQuickActionButton(
            'Remind me',
            Icons.alarm,
            Colors.green,
            () => onQuickAction('remind'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 16),
          label: Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            elevation: 3,
            shadowColor: color.withOpacity(0.3),
          ),
        ),
      ),
    );
  }
}