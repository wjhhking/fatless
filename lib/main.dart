import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/onboarding/user_survey_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/chat/chat_screen.dart';
import 'screens/chat/group_chat_screen.dart';
import 'screens/chat/fitness_chat_screen.dart';
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
        '/home': (context) => const HomeScreen(),
        '/chat': (context) => const ChatScreen(),
        '/group-chat': (context) => const GroupChatScreen(),
        '/fitness-chat': (context) => const FitnessChatScreen(),
        '/meal': (context) => const MealScreen(),
        '/workout': (context) => const WorkoutScreen(),
        '/survey': (context) => const UserSurveyScreen(),
      },
      ),
    );
  }
}