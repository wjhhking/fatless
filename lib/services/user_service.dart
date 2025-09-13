import 'package:flutter/foundation.dart';
import '../models/user_profile.dart';

class UserService extends ChangeNotifier {
  UserProfile? _currentUser;
  bool _isOnboardingComplete = false;

  UserProfile? get currentUser => _currentUser;
  bool get isOnboardingComplete => _isOnboardingComplete;

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
