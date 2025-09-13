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



  final List<String> _introTexts = [
    "Is this you when stepping on the scale?",
    "Don't obsess over weights calories",
    "We care all about YOU"
  ];

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
        child: GestureDetector(
          onTap: () {
            if (_currentStep < 2) {
              setState(() {
                _currentStep++;
              });
            } else if (_currentStep == 2) {
              setState(() {
                _currentStep = 3; // Move to first question
              });
            }
          },
          child: _currentStep < 3
            ? _buildIntroSection()
            : _buildQuestionSection(),
        ),
      ),
    );
  }

  Widget _buildIntroSection() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
          child: const Center(
            child: Icon(
              Icons.play_circle_outline,
              color: Colors.white,
              size: 100,
            ),
          ),
        ),
        Positioned(
          bottom: 100,
          left: 20,
          right: 20,
          child: Column(
            children: [
              Text(
                _introTexts[_currentStep],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                _currentStep < 2 ? 'Tap to continue' : 'Tap to start questions',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              LinearProgressIndicator(
                value: (_currentStep + 1) / 3,
                backgroundColor: Colors.grey[800],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.purple),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionSection() {
    final questionIndex = _currentStep - 3;
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
              _questions[questionIndex],
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
                itemCount: _options[questionIndex].length,
                itemBuilder: (context, index) {
                  final option = _options[questionIndex][index];
                  final isSelected = _selectedOptions[questionIndex].contains(option);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedOptions[questionIndex].remove(option);
                        } else {
                          _selectedOptions[questionIndex].add(option);
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
                if (questionIndex > 0)
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
                    if (questionIndex == 2) {
                      // Last question, navigate directly to survey
                      _navigateToProfile();
                    } else {
                      setState(() {
                        _currentStep++;
                      });
                    }
                  },
                  child: Text(questionIndex == 2 ? 'Continue' : 'Next'),
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
