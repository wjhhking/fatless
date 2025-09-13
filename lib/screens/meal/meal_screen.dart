import 'package:flutter/material.dart';
import '../../widgets/common/bottom_navigation_widget.dart';
import '../../models/recipe.dart';

class MealScreen extends StatefulWidget {
  const MealScreen({super.key});

  @override
  State<MealScreen> createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> with TickerProviderStateMixin {
  bool _animationCompleted = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black54),
          onPressed: () {},
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: const Icon(
              Icons.account_circle,
              color: Color(0xFF4A90E2),
              size: 32,
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigationWidget(currentRoute: '/meal'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Craving Question Section
              const SizedBox(height: 10),
              const Text(
                'Starting or Craving?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2E5984),
                ),
              ),
              const SizedBox(height: 15),
              
              // Burger Image Section with Animation
              Container(
                width: double.infinity,
                height: 280,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: GestureDetector(
                      onTap: () {
                        if (!_animationCompleted) {
                          _animationController.forward().then((_) {
                            setState(() {
                              _animationCompleted = true;
                            });
                          });
                        }
                      },
                    child: Stack(
                      children: [
                        // Base colorful burger image
                        Center(
                          child: Image.asset(
                            'assets/images/burger_colorful.png',
                            width: 230,
                            height: 230,
                            fit: BoxFit.contain,
                          ),
                        ),
                        // Animated blue burger overlay
                        AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            return ClipRect(
                              clipper: _VerticalLineClipper(_animation.value),
                              child: Center(
                                child: Image.asset(
                                  'assets/images/burger_as_blue.png',
                                  width: 230,
                                  height: 230,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            );
                          },
                        ),
                        // Replay button
                        if (_animationCompleted)
                          Positioned(
                            top: 10,
                            right: 10,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _animationCompleted = false;
                                });
                                _animationController.reset();
                                _animationController.forward().then((_) {
                                  setState(() {
                                    _animationCompleted = true;
                                  });
                                });
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.replay,
                                  color: Color(0xFF2E5984),
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        // Magical animated line with sparkles
                        AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            return Positioned(
                              left: _animation.value * 280 - 2,
                              top: 0,
                              bottom: 0,
                              child: Container(
                                width: 4,
                                decoration: BoxDecoration(
                                   gradient: const LinearGradient(
                                     begin: Alignment.topCenter,
                                     end: Alignment.bottomCenter,
                                     colors: [
                                       Color(0xFFF5F5F5),
                                       Color(0xFFE8E8E8),
                                       Color(0xFFC0C0C0),
                                       Color(0xFF808080),
                                     ],
                                   ),
                                   boxShadow: [
                                     BoxShadow(
                                       color: Colors.white.withOpacity(0.9),
                                       blurRadius: 8,
                                       spreadRadius: 2,
                                     ),
                                     BoxShadow(
                                       color: const Color(0xFFC0C0C0).withOpacity(0.7),
                                       blurRadius: 12,
                                       spreadRadius: 1,
                                     ),
                                   ],
                                 ),
                              ),
                            );
                          },
                        ),
                        // Sparkle effects around the line
                        AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            return Positioned(
                              left: _animation.value * 280 - 10,
                              top: 20,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.8 * _animation.value),
                                  boxShadow: [
                                     BoxShadow(
                                       color: const Color(0xFFC0C0C0).withOpacity(0.6),
                                       blurRadius: 6,
                                       spreadRadius: 1,
                                     ),
                                   ],
                                ),
                              ),
                            );
                          },
                        ),
                        AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            return Positioned(
                              left: _animation.value * 280 - 5,
                              bottom: 30,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFFE8E8E8).withOpacity(0.9 * _animation.value),
                                   boxShadow: [
                                     BoxShadow(
                                       color: const Color(0xFFC0C0C0).withOpacity(0.5),
                                       blurRadius: 4,
                                       spreadRadius: 1,
                                     ),
                                   ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 25),
              
              // Alternative Recipe Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF4A90E2),
                          ),
                          child: const Icon(
                            Icons.lightbulb_outline,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Alternative\nRecipe',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2E5984),
                            height: 1.2,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.add,
                          color: Color(0xFF4A90E2),
                          size: 24,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Display recipes from Recipe data model
                    ...RecipeData.popularRecipes.asMap().entries.map((entry) {
                      final index = entry.key;
                      final recipe = entry.value;
                      final backgroundColor = index % 2 == 0 
                        ? const Color(0xFFE8F4FD) 
                        : const Color(0xFFFFF0F5);
                      
                      return Column(
                        children: [
                          if (index > 0) const SizedBox(height: 16),
                          _buildAlternativeRecipe(recipe, backgroundColor),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildAlternativeRecipe(
    Recipe recipe,
    Color backgroundColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Recipe Image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                recipe.imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Recipe Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E5984),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  recipe.ingredients,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      recipe.calories,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E5984),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      recipe.time,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E5984),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VerticalLineClipper extends CustomClipper<Rect> {
  final double progress;

  _VerticalLineClipper(this.progress);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(
      0,
      0,
      progress * 280,
      280,
    );
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return oldClipper is _VerticalLineClipper && oldClipper.progress != progress;
  }
}
