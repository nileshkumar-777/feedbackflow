import 'package:feedback_flow/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the basic login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const FeedbackFlowApp());

    expect(find.text('Feedback Flow'), findsOneWidget);
    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Forgot Password?'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text("Don't have an account? "), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);
  });

  testWidgets('validates required login fields', (WidgetTester tester) async {
    await tester.pumpWidget(const FeedbackFlowApp());

    await tester.tap(find.text('Login'));
    await tester.pump();

    expect(find.text('Enter your email address'), findsOneWidget);
    expect(find.text('Enter your password'), findsOneWidget);
  });
}
