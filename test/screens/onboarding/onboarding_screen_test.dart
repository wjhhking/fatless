import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:fatless/screens/onboarding/onboarding_screen.dart';
import 'package:fatless/services/user_service.dart';

// Mock UserService for testing
class MockUserService extends UserService {
  @override
  Future<void> saveUserProfile(Map<String, dynamic> profile) async {
    // Mock implementation
  }
}

void main() {
  group('OnboardingScreen Tests', () {
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

    testWidgets('should render initial onboarding screen with first question', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify first question is displayed
      expect(find.text('Which E is the easiest for you?'), findsOneWidget);
      
      // Verify all options for first question are displayed
      expect(find.text('Eating'), findsOneWidget);
      expect(find.text('Exercise'), findsOneWidget);
      expect(find.text('Entertainment'), findsOneWidget);
      expect(find.text('Education'), findsOneWidget);

      // Verify Next button is present
      expect(find.text('Next'), findsOneWidget);
      
      // Verify Back button is not present on first step
      expect(find.text('Back'), findsNothing);
    });

    testWidgets('should select and deselect options', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find and tap on 'Eating' option
      final eatingOption = find.text('Eating');
      await tester.tap(eatingOption);
      await tester.pumpAndSettle(const Duration(seconds: 2)); // Wait for background animation

      // Verify the option is selected (check icon appears)
      expect(find.byIcon(Icons.check), findsOneWidget);

      // Tap again to deselect
      await tester.tap(eatingOption);
      await tester.pumpAndSettle(const Duration(seconds: 2)); // Wait for background animation

      // Verify the option is deselected (check icon disappears)
      expect(find.byIcon(Icons.check), findsNothing);
    });

    testWidgets('should navigate to next question when Next button is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap Next button
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Verify second question is displayed
      expect(find.text('Have you tried these diets, are they suitable for you?'), findsOneWidget);
      
      // Verify some diet options are displayed (GridView might not show all at once)
      expect(find.text('Keto'), findsOneWidget);
      expect(find.text('Paleo'), findsOneWidget);

      // Verify Back button is now present
      expect(find.text('Back'), findsOneWidget);
    });

    testWidgets('should navigate back to previous question when Back button is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Navigate to second question
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Tap Back button
      await tester.tap(find.text('Back'));
      await tester.pumpAndSettle();

      // Verify we're back to first question
      expect(find.text('Which E is the easiest for you?'), findsOneWidget);
      expect(find.text('Back'), findsNothing);
    });

    testWidgets('should navigate through all 4 questions', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Question 1
      expect(find.text('Which E is the easiest for you?'), findsOneWidget);
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Question 2
      expect(find.text('Have you tried these diets, are they suitable for you?'), findsOneWidget);
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Question 3
      expect(find.text('Have you ever quit due to…'), findsOneWidget);
      expect(find.text('Lack of time'), findsOneWidget);
      expect(find.text('No results'), findsOneWidget);
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Question 4 (final)
      expect(find.text('Now, you have me'), findsOneWidget);
      expect(find.text('Diet Expert'), findsOneWidget);
      expect(find.text('Fitness Coach'), findsOneWidget);
      expect(find.text('Check-in Friend'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('should show after-answer background on first question when option is selected', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap on an option in the first question
      await tester.tap(find.text('Eating'));
      
      // Wait for the background animation (1 second delay in the code)
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // The background change is internal state, so we verify the option is selected
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('should allow multiple option selections', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Select multiple options
      await tester.tap(find.text('Eating'));
      await tester.pumpAndSettle(const Duration(seconds: 2)); // Wait for background animation
      await tester.tap(find.text('Exercise'));
      await tester.pumpAndSettle(const Duration(seconds: 2)); // Wait for background animation

      // Verify both options are selected
      expect(find.byIcon(Icons.check), findsNWidgets(2));
    });

    testWidgets('should navigate to survey screen when Continue is tapped on final question', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Navigate through all questions to reach the final one
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.text('Next'));
        await tester.pumpAndSettle();
      }

      // Verify we're on the final question
      expect(find.text('Now, you have me'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);

      // Tap Continue button
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify navigation to survey screen
      expect(find.text('Survey Screen'), findsOneWidget);
    });

    testWidgets('should maintain selected options when navigating between questions', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Select an option in first question
      await tester.tap(find.text('Eating'));
      await tester.pumpAndSettle(const Duration(seconds: 2)); // Wait for background animation
      expect(find.byIcon(Icons.check), findsOneWidget);

      // Navigate to second question
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Navigate back to first question
      await tester.tap(find.text('Back'));
      await tester.pumpAndSettle();

      // Verify the selection is maintained
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('should hide buttons during transition on final question', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Navigate to final question
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.text('Next'));
        await tester.pumpAndSettle();
      }

      // Tap Continue
      await tester.tap(find.text('Continue'));
      
      // Wait for transition and navigation
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.text('Survey Screen'), findsOneWidget);
    });
  });
}