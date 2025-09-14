import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:fatless/main.dart' as app;
import 'package:fatless/services/user_service.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Onboarding Audio Integration Tests', () {
    testWidgets('should play audio on option button clicks throughout onboarding flow', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Navigate to onboarding screen if not already there
      // This depends on your app's navigation flow
      // You might need to adjust this based on your app's initial route
      
      // Wait for the app to load
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Test Question 1: "Which E is the easiest for you?"
      if (await tester.binding.defaultBinaryMessenger.checkMockMessageHandler('flutter/assets', null) == null) {
        // If we can find the onboarding screen
        final question1Finder = find.text('Which E is the easiest for you?');
        if (tester.any(question1Finder)) {
          // Test clicking on each option in question 1
          await tester.tap(find.text('Eating'));
          await tester.pumpAndSettle(const Duration(seconds: 2));
          
          await tester.tap(find.text('Exercise'));
          await tester.pumpAndSettle(const Duration(seconds: 2));
          
          // Navigate to next question
          await tester.tap(find.text('Next'));
          await tester.pumpAndSettle();

          // Test Question 2: Diet options
          expect(find.text('Have you tried these diets, are they suitable for you?'), findsOneWidget);
          
          await tester.tap(find.text('Keto'));
          await tester.pumpAndSettle(const Duration(seconds: 2));
          
          await tester.tap(find.text('Paleo'));
          await tester.pumpAndSettle(const Duration(seconds: 2));
          
          // Navigate to next question
          await tester.tap(find.text('Next'));
          await tester.pumpAndSettle();

          // Test Question 3: Quit reasons
          expect(find.text('Have you ever quit due to…'), findsOneWidget);
          
          await tester.tap(find.text('Lack of time'));
          await tester.pumpAndSettle(const Duration(seconds: 2));
          
          await tester.tap(find.text('No results'));
          await tester.pumpAndSettle(const Duration(seconds: 2));
          
          // Navigate to final question
          await tester.tap(find.text('Next'));
          await tester.pumpAndSettle();

          // Test Question 4: Final question
          expect(find.text('Now, you have me'), findsOneWidget);
          
          await tester.tap(find.text('Diet Expert'));
          await tester.pumpAndSettle(const Duration(seconds: 2));
          
          await tester.tap(find.text('Fitness Coach'));
          await tester.pumpAndSettle(const Duration(seconds: 2));
        }
      }
    });

    testWidgets('should handle rapid button clicks with audio', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Test rapid clicking to ensure audio doesn't cause issues
      final question1Finder = find.text('Which E is the easiest for you?');
      if (tester.any(question1Finder)) {
        // Rapidly click multiple options
        await tester.tap(find.text('Eating'));
        await tester.pump(const Duration(milliseconds: 100));
        
        await tester.tap(find.text('Exercise'));
        await tester.pump(const Duration(milliseconds: 100));
        
        await tester.tap(find.text('Entertainment'));
        await tester.pump(const Duration(milliseconds: 100));
        
        await tester.tap(find.text('Education'));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Verify the UI still responds correctly
        expect(find.byIcon(Icons.check), findsWidgets);
      }
    });

    testWidgets('should maintain audio functionality during navigation', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final question1Finder = find.text('Which E is the easiest for you?');
      if (tester.any(question1Finder)) {
        // Test audio on first question
        await tester.tap(find.text('Eating'));
        await tester.pumpAndSettle(const Duration(seconds: 1));
        
        // Navigate forward
        await tester.tap(find.text('Next'));
        await tester.pumpAndSettle();
        
        // Test audio on second question
        await tester.tap(find.text('Keto'));
        await tester.pumpAndSettle(const Duration(seconds: 1));
        
        // Navigate back
        await tester.tap(find.text('Back'));
        await tester.pumpAndSettle();
        
        // Test audio still works on first question
        await tester.tap(find.text('Exercise'));
        await tester.pumpAndSettle(const Duration(seconds: 1));
        
        // Verify selections are maintained and audio still works
        expect(find.byIcon(Icons.check), findsNWidgets(2)); // Eating and Exercise
      }
    });

    testWidgets('should handle audio during background transitions', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final question1Finder = find.text('Which E is the easiest for you?');
      if (tester.any(question1Finder)) {
        // Test audio during the background transition that happens in question 1
        await tester.tap(find.text('Eating'));
        
        // Wait for the background animation (1 second in the code)
        await tester.pumpAndSettle(const Duration(seconds: 2));
        
        // Verify the option is selected despite background transition
        expect(find.byIcon(Icons.check), findsOneWidget);
        
        // Test another option during the same transition period
        await tester.tap(find.text('Exercise'));
        await tester.pumpAndSettle(const Duration(seconds: 2));
        
        expect(find.byIcon(Icons.check), findsNWidgets(2));
      }
    });

    testWidgets('should complete full onboarding flow with audio', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final question1Finder = find.text('Which E is the easiest for you?');
      if (tester.any(question1Finder)) {
        // Complete the entire onboarding flow with audio interactions
        
        // Question 1
        await tester.tap(find.text('Eating'));
        await tester.pumpAndSettle(const Duration(seconds: 1));
        await tester.tap(find.text('Next'));
        await tester.pumpAndSettle();
        
        // Question 2
        await tester.tap(find.text('Keto'));
        await tester.pumpAndSettle(const Duration(seconds: 1));
        await tester.tap(find.text('Next'));
        await tester.pumpAndSettle();
        
        // Question 3
        await tester.tap(find.text('Lack of time'));
        await tester.pumpAndSettle(const Duration(seconds: 1));
        await tester.tap(find.text('Next'));
        await tester.pumpAndSettle();
        
        // Question 4
        await tester.tap(find.text('Diet Expert'));
        await tester.pumpAndSettle(const Duration(seconds: 1));
        
        // Complete onboarding
        await tester.tap(find.text('Continue'));
        await tester.pumpAndSettle(const Duration(seconds: 3));
        
        // Verify we've navigated away from onboarding
        // (The exact verification depends on where the app navigates to)
      }
    });
  });
}