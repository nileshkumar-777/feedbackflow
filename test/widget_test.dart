import 'package:feedback_flow/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the basic login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const FeedbackFlowApp());
    await tester.pumpAndSettle(
      const Duration(seconds: 4),
    ); // Wait for the loading animation to finish

    expect(find.text('Welcome Back!'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Sign In With Google'), findsOneWidget);
  });

  testWidgets('validates required login fields', (WidgetTester tester) async {
    await tester.pumpWidget(const FeedbackFlowApp());
    await tester.pumpAndSettle(const Duration(seconds: 4));

    await tester.tap(find.text('Login'));
    await tester.pump();

    expect(find.text('Enter Email'), findsOneWidget);
  });
}
