import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:fatless/screens/onboarding/onboarding_screen.dart';
import 'package:fatless/services/user_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([UserService])
import 'debug_onboarding_test.mocks.dart';

void main() {
  testWidgets('Debug onboarding screen widgets', (WidgetTester tester) async {
    final mockUserService = MockUserService();
    
    await tester.pumpWidget(
      ChangeNotifierProvider<UserService>(
        create: (_) => mockUserService,
        child: MaterialApp(
          home: const OnboardingScreen(),
          routes: {
            '/survey': (context) => const Scaffold(
              body: Center(child: Text('Survey Screen')),
            ),
          },
        ),
      ),
    );
    
    await tester.pumpAndSettle();
    
    // Print all widgets to see what's available
    print('=== All widgets before tap ===');
    final allWidgets = find.byType(Widget);
    for (int i = 0; i < allWidgets.evaluate().length && i < 20; i++) {
      try {
        final widget = allWidgets.evaluate().elementAt(i).widget;
        print('Widget $i: ${widget.runtimeType}');
        if (widget is Icon) {
          print('  Icon data: ${widget.icon}');
        }
        if (widget is Text) {
          print('  Text: ${widget.data}');
        }
      } catch (e) {
        print('Widget $i: Error - $e');
      }
    }
    
    // Verify we're on question 1
    expect(find.text('Which E is the easiest for you?'), findsOneWidget);
    
    // Tap on 'Eating' option
    await tester.tap(find.text('Eating'));
    await tester.pump(); // Trigger state change immediately
    
    print('=== All widgets after tap (immediate) ===');
    
    // Check for Container with check icon (white circle with blue check)
    final checkContainers = find.byWidgetPredicate((widget) {
      if (widget is Container && widget.decoration is BoxDecoration) {
        final decoration = widget.decoration as BoxDecoration;
        return decoration.color == Colors.white && decoration.shape == BoxShape.circle;
      }
      return false;
    });
    print('Check containers found: ${checkContainers.evaluate().length}');
    
    // Also check for any Icon widgets with Icons.check
    final checkIcons = find.byWidgetPredicate((widget) {
      return widget is Icon && widget.icon == Icons.check;
    });
    print('Check icons found: ${checkIcons.evaluate().length}');
    
    // Look specifically for Icons immediately after state change
    final iconFinder = find.byType(Icon);
    print('Found ${iconFinder.evaluate().length} Icon widgets immediately');
    
    // Wait for all async operations to complete (audio + background transition)
    await tester.pump(const Duration(milliseconds: 100)); // Wait for audio to start
    await tester.pump(const Duration(seconds: 1)); // Wait for background transition
    await tester.pumpAndSettle(); // Wait for all animations to complete
    
    print('=== After async operations ===');
    
    // Check for Container with check icon again
    final checkContainersAfter = find.byWidgetPredicate((widget) {
      if (widget is Container && widget.decoration is BoxDecoration) {
        final decoration = widget.decoration as BoxDecoration;
        return decoration.color == Colors.white && decoration.shape == BoxShape.circle;
      }
      return false;
    });
    print('Check containers found after async: ${checkContainersAfter.evaluate().length}');
    
    // Check for Icons again
    final checkIconsAfter = find.byWidgetPredicate((widget) {
      return widget is Icon && widget.icon == Icons.check;
    });
    print('Check icons found after async: ${checkIconsAfter.evaluate().length}');
    
    final iconFinderAfter = find.byType(Icon);
    print('Found ${iconFinderAfter.evaluate().length} Icon widgets after async');
    for (int i = 0; i < iconFinderAfter.evaluate().length; i++) {
      final iconWidget = iconFinderAfter.evaluate().elementAt(i).widget as Icon;
      print('Icon $i: ${iconWidget.icon} (color: ${iconWidget.color})');
    }
    
    print('=== All widgets after delay ===');
    final allWidgetsFinal = find.byType(Widget);
    for (int i = 0; i < allWidgetsFinal.evaluate().length && i < 20; i++) {
      try {
        final widget = allWidgetsFinal.evaluate().elementAt(i).widget;
        print('Widget $i: ${widget.runtimeType}');
        if (widget is Icon) {
          print('  Icon data: ${widget.icon}');
        }
        if (widget is Text) {
          print('  Text: ${widget.data}');
        }
      } catch (e) {
        print('Widget $i: Error - $e');
      }
    }
    
    // Check for check icons
    print('=== Looking for check icons ===');
    final checkIconsDelayed = find.byIcon(Icons.check);
    print('Found ${checkIconsDelayed.evaluate().length} check icons');
    
    // This test is just for debugging, so we don't assert anything
  });
}