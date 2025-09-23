import 'package:flutter/material.dart';
import 'package:integration_test/integration_test.dart';
import 'package:new_boilerplate/core/serviceLocator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_boilerplate/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Login uses mock repo", (tester) async {
    // Setup test dependencies
    setupLocator(isTest: true);

    app.main();
    await tester.pumpAndSettle();

    // Enter username/password
    await tester.enterText(find.byType(TextField).at(0), "Ajay");
    await tester.enterText(find.byType(TextField).at(1), "1234");

    // Tap login
    await tester.tap(find.text("Login"));
    await tester.pumpAndSettle();

    // Verify output
    expect(find.text("Welcome Ajay (mock repo)"), findsOneWidget);
  });
}
