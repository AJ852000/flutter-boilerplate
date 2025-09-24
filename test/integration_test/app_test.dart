import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';
import 'package:new_boilerplate/features/auth/bloc/auth_bloc.dart';
import 'package:new_boilerplate/features/auth/view/login_provider.dart';
import '../mocks/auth_repository_test.mocks.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthRepository mockRepo;

  setUp(() {
    mockRepo = MockAuthRepository();
  });

  testWidgets("Login uses mockito mock repo", (tester) async {
    when(mockRepo.login('Ajay', '1234'))
        .thenAnswer((_) async => 'Welcome Ajay (mockito)');

    await tester.pumpWidget(
      MaterialApp(
        home: LoginProvider(authBloc: AuthBloc(repo: mockRepo)),
      ),
    );

    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), 'Ajay');
    await tester.enterText(find.byType(TextField).at(1), '1234');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Welcome Ajay (mockito)'), findsOneWidget);
    verify(mockRepo.login('Ajay', '1234')).called(1);
  });
}
