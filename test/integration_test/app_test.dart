import 'package:flutter/material.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_boilerplate/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Login uses mock repo", (tester) async {
    app.main(useMock: true);
    await tester.pumpAndSettle();

    // Enter username/password
    await tester.enterText(find.byType(TextField).at(0), "Ajay");
    await tester.enterText(find.byType(TextField).at(1), "1234");

    // Tap login
    final loginButton = find.widgetWithText(ElevatedButton, 'Login');
    await tester.tap(loginButton);

    await tester.pump();
    await tester.pumpAndSettle();

    // Verify SnackBar is shown
    final snackBarFinder = find.byType(SnackBar);
    expect(snackBarFinder, findsOneWidget);

    // Verify text (adjust once we know the actual output)
    expect(
      find.descendant(
        of: snackBarFinder,
        matching: find.text("Welcome Ajay (mock repo)"),
      ),
      findsOneWidget,
    );
  });
}
