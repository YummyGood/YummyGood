import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:yummygood/main.dart';

void main() {
  testWidgets('Widget testing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // find the sign up button
    expect(find.byKey(const Key("signup_btn")), findsOneWidget);

    // press button and check if signup form shows to ensure navigation is properly working
    await tester.tap(find.byKey(const Key("signup_btn")));
    await tester.pump();
    await tester.pump();
    
    expect(find.byKey(const Key("title")), findsOneWidget);    
    await tester.pumpWidget(MyApp());
    await tester.pump();

    // find the login button
    expect(find.byKey(const Key("login_btn")), findsOneWidget);
    await tester.tap(find.byKey(const Key("login_btn")), warnIfMissed: false);

    await tester.pump();
    await tester.pump();
    expect(find.byKey(const Key("title")), findsOneWidget);
  });
}
