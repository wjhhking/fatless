import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/user_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentStep = 0;
  final PageController _pageController = PageController();

  final List<String> _questions = [
    "Which E is the easiest for you?",
    "Have you tried these diets, are they suitable for you?",
    "Have you ever quit due to…"
  ];

  final List<List<String>> _options = [
    ["Eating", "Exercise", "Entertainment", "Education"],
    ["Keto", "Paleo", "Vegan", "Mediterranean", "Low-carb"],
    ["Lack of time", "No results", "Too expensive", "Too difficult", "Boring"]
  ];

  final List<List<String>> _selectedOptions = [[], [], []];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: _buildQuestionSection(),
      ),
    );
  }

  Widget _buildQuestionSection() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.purple, Colors.black],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 60),
            Text(
              _questions[_currentStep],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _options[_currentStep].length,
                itemBuilder: (context, index) {
                  final option = _options[_currentStep][index];
                  final isSelected = _selectedOptions[_currentStep].contains(option);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedOptions[_currentStep].remove(option);
                        } else {
                          _selectedOptions[_currentStep].add(option);
                        }
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.purple : Colors.grey[800],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected ? Colors.white : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              option,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (isSelected) ...[
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentStep > 0)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _currentStep--;
                      });
                    },
                    child: const Text('Back'),
                  )
                else
                  const SizedBox(),
                ElevatedButton(
                  onPressed: () {
                    if (_currentStep == 2) {
                      // Last question, navigate directly to survey
                      _navigateToProfile();
                    } else {
                      setState(() {
                        _currentStep++;
                      });
                    }
                  },
                  child: Text(_currentStep == 2 ? 'Continue' : 'Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    _startAutoProgression();
  }

  void _startAutoProgression() {
    // Remove auto-progression, make it tap-based for better control
    // Future.delayed(const Duration(seconds: 3), () {
    //   if (_currentStep < 2 && mounted) {
    //     setState(() {
    //       _currentStep++;
    //     });
    //     _startAutoProgression();
    //   }
    // });
  }

  void _navigateToProfile() {
    // Pass the collected onboarding data to the profile screen
    Navigator.pushReplacementNamed(
      context,
      '/survey',
      arguments: {
        'exercisePreferences': _selectedOptions[0],
        'dietExperience': _selectedOptions[1],
        'quitReasons': _selectedOptions[2],
      },
    );
  }
}
