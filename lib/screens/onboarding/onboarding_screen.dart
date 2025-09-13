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
  bool _showAfterAnswerBackground = false;
  String _currentBackgroundImage = '';

  final List<String> _introTexts = [
    "Is this you when stepping on the scale?",
    "Don't obsess over weights calories",
    "We care all about YOU",
  ];

  final List<String> _questions = [
    "Which E is the easiest for you?",
    "Have you tried these diets, are they suitable for you?",
    "Have you ever quit due to…",
  ];

  final List<List<String>> _options = [
    ["Eating", "Exercise", "Entertainment", "Education"],
    ["Keto", "Paleo", "Vegan", "Mediterranean", "Low-carb"],
    ["Lack of time", "No results", "Too expensive", "Too difficult", "Boring"],
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
                style: TextStyle(color: Colors.grey[400], fontSize: 16),
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
    return ClipRect(
      child: AnimatedContainer(
        duration: const Duration(seconds: 1),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: _getBackgroundImage(context),
          color: _currentBackgroundImage.isEmpty ? Colors.black : null,
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
                    crossAxisCount: 1,
                    childAspectRatio: 6,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 15,
                  ),
                  itemCount: _options[_currentStep].length,
                  itemBuilder: (context, index) {
                    final option = _options[_currentStep][index];
                    final isSelected = _selectedOptions[_currentStep].contains(
                      option,
                    );

                    return GestureDetector(
                      onTap: () async {
                        setState(() {
                          if (isSelected) {
                            _selectedOptions[_currentStep].remove(option);
                          } else {
                            _selectedOptions[_currentStep].add(option);
                          }
                        });

                        // Show 'after answer' background for 1 second in question 1
                        if (_currentStep == 0) {
                          setState(() {
                            _showAfterAnswerBackground = true;
                          });
                          await Future.delayed(const Duration(seconds: 1));
                          if (mounted) {
                            setState(() {
                              _showAfterAnswerBackground = false;
                            });
                          }
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF5A5A5A)
                              : const Color(0xFF3A3A3A),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: isSelected
                                ? Colors.white.withOpacity(0.5)
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  option,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Color(0xFF4FC3F7),
                                    size: 16,
                                  ),
                                ),
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
                    onPressed: () async {
                      if (_currentStep == 2) {
                        // Last question, navigate directly to survey
                        _navigateToProfile();
                      } else {
                        // Update the question content and background
                        setState(() {
                          _currentStep++;
                          _updateBackgroundForStep();
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
      ),
    );
  }

  DecorationImage? _getBackgroundImage(BuildContext context) {
    String imagePath = '';

    if (_currentStep == 0 && _showAfterAnswerBackground) {
      imagePath = 'assets/images/onboarding Q1 after answer - no text.png';
    } else if (_currentStep == 1) {
      imagePath = 'assets/images/onboarding Q2 - no text.png';
    } else if (_currentStep == 2) {
      imagePath = 'assets/images/onboarding Q3 - no text.png';
    }

    if (imagePath.isNotEmpty) {
      return DecorationImage(
        image: AssetImage(imagePath),
        fit: BoxFit.fitWidth,
        alignment: Alignment.center,
      );
    }

    return null;
  }

  void _updateBackgroundForStep() {
    switch (_currentStep) {
      case 1:
        _currentBackgroundImage = 'assets/images/onboarding Q2 - no text.png';
        break;
      case 2:
        _currentBackgroundImage = 'assets/images/onboarding Q3 - no text.png';
        break;
      default:
        _currentBackgroundImage = '';
    }
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
