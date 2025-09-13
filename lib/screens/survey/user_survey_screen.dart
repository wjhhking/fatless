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
  String _selectedAvatar = 'avatar1';

  final List<String> _avatarOptions = ['avatar1', 'avatar2', 'avatar3'];

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
    _declarationController.text = 'Every time I crave for snacks, I will donate 5 dollars to Lay\'s as a tribute.';
    
    // Get onboarding data from navigation arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        setState(() {
          _exercisePreferences = List<String>.from(args['exercisePreferences'] ?? []);
          _dietExperience = List<String>.from(args['dietExperience'] ?? []);
          _quitReasons = List<String>.from(args['quitReasons'] ?? []);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Basic Information'),
              _buildTextField('Name', _nameController),
              _buildTextField('Age', _ageController, isNumber: false),
              _buildGenderSelector(),
              const SizedBox(height: 20),

              _buildSectionTitle('Physical Information'),
              _buildTextField('Height (cm)', _heightController, isNumber: false),
              _buildTextField('Current Weight (kg)', _currentWeightController, isNumber: true),
              _buildTextField('Target Weight (kg)', _targetWeightController, isNumber: true),
              const SizedBox(height: 20),

              _buildSectionTitle('Choose Your Avatar'),
              _buildAvatarSelector(),
              const SizedBox(height: 20),

              if (_exercisePreferences.isNotEmpty || _dietExperience.isNotEmpty || _quitReasons.isNotEmpty) ...[
                _buildSectionTitle('Your Preferences'),
                _buildPreferencesDisplay(),
                const SizedBox(height: 20),
              ],

              _buildSectionTitle('Weight Loss Declaration'),
              _buildTextField('Your commitment statement', _declarationController, maxLines: 3),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    'Save Profile',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.purple,
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isNumber = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.white,
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
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Row(
            children: ['Female', 'Male', 'Other'].map((gender) {
              return Expanded(
                child: RadioListTile<String>(
                  title: Text(gender),
                  value: gender,
                  groupValue: _selectedGender,
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

  Widget _buildAvatarSelector() {
    return SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _avatarOptions.map((avatar) {
          final isSelected = _selectedAvatar == avatar;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedAvatar = avatar;
              });
            },
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.purple : Colors.grey,
                  width: 3,
                ),
                color: Colors.grey[300],
              ),
              child: Icon(
                Icons.person,
                size: 40,
                color: isSelected ? Colors.purple : Colors.grey[600],
              ),
            ),
          );
        }).toList(),
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
        color: Colors.purple[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.purple[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Based on your onboarding responses:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.purple,
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
                  color: Colors.purple[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  pref,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.purple,
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
        exercisePreferences: _exercisePreferences,
        dietExperience: _dietExperience,
        quitReasons: _quitReasons,
        avatar: _selectedAvatar,
        weightLossDeclaration: _declarationController.text,
      );

      userService.setUser(user);
      userService.completeOnboarding();

      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }
}
