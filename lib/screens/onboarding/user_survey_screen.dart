import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_profile.dart';
import '../../services/user_service.dart';

class UserSurveyScreen extends StatefulWidget {
  const UserSurveyScreen({super.key});

  @override
  State<UserSurveyScreen> createState() => _UserSurveyScreenState();
}

class _UserSurveyScreenState extends State<UserSurveyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _currentWeightController = TextEditingController();
  final _targetWeightController = TextEditingController();
  final _declarationController = TextEditingController();

  String _selectedGender = 'Female';
  String _selectedMbti = 'ENFP';
  String _selectedRelationshipStatus = "I'm not serious for now";
  final List<String> _mbtiOptions = [
    'INTJ',
    'INTP',
    'ENTJ',
    'ENTP',
    'INFJ',
    'INFP',
    'ENFJ',
    'ENFP',
    'ISTJ',
    'ISFJ',
    'ESTJ',
    'ESFJ',
    'ISTP',
    'ISFP',
    'ESTP',
    'ESFP',
  ];
  final List<String> _relationshipOptions = [
    "I'm not serious for now",
    'Single',
    'In a relationship',
    'Married',
    'It\'s complicated',
  ];

  // Onboarding data passed from previous screen
  List<String> _exercisePreferences = [];
  List<String> _dietExperience = [];
  List<String> _quitReasons = [];

  @override
  void initState() {
    super.initState();
    // Set default values
    _nameController.text = 'Cheryl';
    _ageController.text = '18';
    _heightController.text = '165';
    _currentWeightController.text = '60';
    _targetWeightController.text = '55';
    _declarationController.text =
        'Every time I crave for snacks, I will donate 5 dollars to Lay\'s as a tribute.';

    // Get onboarding data from navigation arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        setState(() {
          _exercisePreferences = List<String>.from(
            args['exercisePreferences'] ?? [],
          );
          _dietExperience = List<String>.from(args['dietExperience'] ?? []);
          _quitReasons = List<String>.from(args['quitReasons'] ?? []);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F4F8),
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
        backgroundColor: const Color(0xFF4A9B8E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/user_survey.png'),
            fit: BoxFit.cover,
            opacity: 0.05,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'To customize for you,\nwe want to know you better...',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF4A9B8E),
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30),

                  _buildSectionTitle('Basic Information'),
                  _buildTextField('Name', _nameController),
                  _buildTextField('Age', _ageController, isNumber: false),
                  _buildGenderSelector(),
                  const SizedBox(height: 20),

                  _buildSectionTitle('Physical Information'),
                  _buildTextField(
                    'Height (cm)',
                    _heightController,
                    isNumber: false,
                  ),
                  _buildTextField(
                    'Current Weight (kg)',
                    _currentWeightController,
                    isNumber: true,
                  ),
                  _buildTextField(
                    'Target Weight (kg)',
                    _targetWeightController,
                    isNumber: true,
                  ),
                  const SizedBox(height: 20),

                  _buildSectionTitle('Personality & Lifestyle'),
                  _buildMbtiSelector(),
                  _buildRelationshipStatusSelector(),
                  const SizedBox(height: 20),



                  if (_exercisePreferences.isNotEmpty ||
                      _dietExperience.isNotEmpty ||
                      _quitReasons.isNotEmpty) ...[
                    _buildSectionTitle('Your Preferences'),
                    _buildPreferencesDisplay(),
                    const SizedBox(height: 20),
                  ],

                  _buildSectionTitle('Weight Loss Declaration'),
                  _buildTextField(
                    'Your commitment statement',
                    _declarationController,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A9B8E),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        'Save Profile',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, top: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFF4A9B8E),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF6B7280)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF4A9B8E), width: 2),
          ),
          filled: true,
          fillColor: const Color(0xFFF9FAFB),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          if (isNumber && int.tryParse(value) == null) {
            return 'Please enter a valid number';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gender',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: ['Female', 'Male', 'Other'].map((gender) {
              return Expanded(
                child: RadioListTile<String>(
                  title: Text(
                    gender,
                    style: const TextStyle(color: Color(0xFF374151)),
                  ),
                  value: gender,
                  groupValue: _selectedGender,
                  activeColor: const Color(0xFF4A9B8E),
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value!;
                    });
                  },
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }



  Widget _buildMbtiSelector() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'MBTI Personality Type',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedMbti,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF4A9B8E),
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
            ),
            items: _mbtiOptions.map((String mbti) {
              return DropdownMenuItem<String>(
                value: mbti,
                child: Text(
                  mbti,
                  style: const TextStyle(color: Color(0xFF374151)),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedMbti = newValue!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRelationshipStatusSelector() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Relationship Status',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedRelationshipStatus,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF4A9B8E),
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
            ),
            items: _relationshipOptions.map((String status) {
              return DropdownMenuItem<String>(
                value: status,
                child: Text(
                  status,
                  style: const TextStyle(color: Color(0xFF374151)),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedRelationshipStatus = newValue!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesDisplay() {
    List<String> allPreferences = [];
    allPreferences.addAll(_exercisePreferences);
    allPreferences.addAll(_dietExperience);
    allPreferences.addAll(_quitReasons);

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F4F8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF4A9B8E).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Based on your onboarding responses:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF4A9B8E),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: allPreferences.map((pref) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF4A9B8E).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  pref,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF4A9B8E),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final userService = Provider.of<UserService>(context, listen: false);
      final targetWeight = int.parse(_targetWeightController.text);
      final userId = userService.generateUserId(targetWeight);

      final user = UserProfile(
        id: userId,
        name: _nameController.text,
        age: _ageController.text,
        gender: _selectedGender,
        height: _heightController.text,
        currentWeight: int.parse(_currentWeightController.text),
        targetWeight: targetWeight,
        mbti: _selectedMbti,
        relationshipStatus: _selectedRelationshipStatus,
        exercisePreferences: _exercisePreferences,
        dietExperience: _dietExperience,
        quitReasons: _quitReasons,
        avatar: 'default',
        weightLossDeclaration: _declarationController.text,
      );

      userService.setUser(user);
      userService.completeOnboarding();

      Navigator.pushReplacementNamed(context, '/home');
    }
  }
}
