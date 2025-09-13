import 'package:flutter/foundation.dart';
import '../models/user_profile.dart';

class UserService extends ChangeNotifier {
  UserProfile? _currentUser;
  bool _isOnboardingComplete = false;

  UserService() {
    _initializeDefaultUser();
  }

  UserProfile? get currentUser => _currentUser;
  bool get isOnboardingComplete => _isOnboardingComplete;

  void _initializeDefaultUser() {
    _currentUser = UserProfile(
      id: 'default_user',
      name: 'Guest User',
      height: '165',
      currentWeight: 125,
      targetWeight: 115,
      age: '25',
      gender: 'Other',
      mbti: 'ENFP',
      relationshipStatus: 'Single',
      exercisePreferences: ['Walking', 'Yoga'],
      dietExperience: ['Calorie counting'],
      quitReasons: ['Lack of motivation'],
      avatar: '😊',
      weightLossDeclaration: 'Ready to start my fitness journey!',
    );
  }

  void setUser(UserProfile user) {
    _currentUser = user;
    notifyListeners();
  }

  void completeOnboarding() {
    _isOnboardingComplete = true;
    notifyListeners();
  }

  String generateUserId(int targetWeight) {
    final now = DateTime.now();
    final dateString = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    return '$dateString$targetWeight';
  }
}
