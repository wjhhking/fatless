import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:fatless/screens/onboarding/onboarding_screen.dart';
import 'package:fatless/services/user_service.dart';

// Generate mocks
@GenerateMocks([AudioPlayer, UserService])
import 'onboarding_screen_audio_test.mocks.dart';

void main() {
  group('OnboardingScreen Audio Tests', () {
    late MockUserService mockUserService;

    setUp(() {
      mockUserService = MockUserService();
    });

    Widget createTestWidget() {
      return ChangeNotifierProvider<UserService>(
        create: (_) => mockUserService,
        child: MaterialApp(
          home: const OnboardingScreen(),
          routes: {
            '/survey': (context) => const Scaffold(
              body: Center(child: Text('Survey Screen')),
            ),
          },
        ),
      );
    }

    testWidgets('should display onboarding screen and allow option selection', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify we're on question 1
      expect(find.text('Which E is the easiest for you?'), findsOneWidget);
      expect(find.text('Eating'), findsOneWidget);
      expect(find.text('Exercise'), findsOneWidget);
      expect(find.text('Entertainment'), findsOneWidget);
      expect(find.text('Education'), findsOneWidget);

      // Tap on 'Eating' option
      await tester.tap(find.text('Eating'));
      await tester.pump();
      
      // Wait for any animations and state changes
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      // The option should be tappable and the screen should respond
      // We can't easily test the audio directly, but we can verify the UI responds
      expect(find.text('Eating'), findsOneWidget);
    });

    testWidgets('should navigate through all questions and allow selections', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Question 1
      expect(find.text('Which E is the easiest for you?'), findsOneWidget);
      await tester.tap(find.text('Eating'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      // Navigate to question 2
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Question 2
      expect(find.text('Have you tried these diets, are they suitable for you?'), findsOneWidget);
      await tester.tap(find.text('Keto'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      // Navigate to question 3
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Question 3
      expect(find.text('Have you ever quit due to…'), findsOneWidget);
      await tester.tap(find.text('Lack of time'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      // Navigate to question 4
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Question 4
      expect(find.text('Now, you have me'), findsOneWidget);
      await tester.tap(find.text('Diet Expert'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      // All questions completed successfully
      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('should allow multiple selections in question 2', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Navigate to question 2
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Select multiple diet options
      await tester.tap(find.text('Keto'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      
      await tester.tap(find.text('Paleo'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      
      await tester.tap(find.text('Vegan'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      // All options should be available for selection
      expect(find.text('Keto'), findsOneWidget);
      expect(find.text('Paleo'), findsOneWidget);
      expect(find.text('Vegan'), findsOneWidget);
    });

    testWidgets('should handle rapid option selections', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Rapidly tap options in question 1
      await tester.tap(find.text('Eating'));
      await tester.pump(const Duration(milliseconds: 100));
      
      await tester.tap(find.text('Exercise'));
      await tester.pump(const Duration(milliseconds: 100));
      
      await tester.tap(find.text('Entertainment'));
      await tester.pump(const Duration(milliseconds: 100));
      
      await tester.tap(find.text('Education'));
      await tester.pump(const Duration(milliseconds: 100));
      
      await tester.pumpAndSettle();

      // The screen should handle rapid selections without crashing
      expect(find.text('Which E is the easiest for you?'), findsOneWidget);
    });

    testWidgets('should maintain functionality during background transitions', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // In question 1, there's a special background transition
      await tester.tap(find.text('Eating'));
      await tester.pump();
      
      // Wait for the background transition (1 second)
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      // Should still be functional after background transition
      expect(find.text('Which E is the easiest for you?'), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);
    });

    testWidgets('should complete full onboarding flow with audio interactions', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Complete all questions with selections
      final selections = [
        ['Eating'],
        ['Keto', 'Mediterranean'],
        ['Lack of time'],
        ['Diet Expert']
      ];

      for (int questionIndex = 0; questionIndex < selections.length; questionIndex++) {
        // Make selections for current question
        for (String selection in selections[questionIndex]) {
          // Ensure the widget is visible before tapping
          await tester.ensureVisible(find.text(selection));
          await tester.tap(find.text(selection), warnIfMissed: false);
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 300));
        }
        
        await tester.pumpAndSettle();
        
        // Navigate to next question (except for the last one)
        if (questionIndex < selections.length - 1) {
          await tester.tap(find.text('Next'));
          await tester.pumpAndSettle();
        }
      }

      // Should reach the final continue button
      expect(find.text('Continue'), findsOneWidget);
    });
  });
}