import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/survey/user_survey_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/chat/chat_screen.dart';
import 'screens/meal/meal_screen.dart';
import 'screens/workout/workout_screen.dart';
import 'services/user_service.dart';

void main() {
  runApp(const FatlessApp());
}

class FatlessApp extends StatelessWidget {
  const FatlessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserService()),
      ],
      child: MaterialApp(
        title: 'Fatless',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const OnboardingScreen(),
          '/survey': (context) => const UserSurveyScreen(),
          '/dashboard': (context) => const DashboardScreen(),
          '/chat': (context) => const ChatScreen(),
          '/meal': (context) => const MealScreen(),
          '/workout': (context) => const WorkoutScreen(),
        },
      ),
    );
  }
}