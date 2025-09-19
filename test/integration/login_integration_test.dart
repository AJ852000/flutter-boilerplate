import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:new_boilerplate/modules/login/bloc/auth_bloc.dart';
import 'package:new_boilerplate/modules/login/repository/auth_repository.dart';
import 'package:new_boilerplate/modules/login/ui/login_page.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late AuthRepository repository;

  setUp(() {
    mockDio = MockDio();
    repository = AuthRepositoryImpl(dio: mockDio);
  });

  testWidgets('Login Success Flow', (WidgetTester tester) async {
    when(() => mockDio.post('/login', data: any(named: 'data')))
        .thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/login'),
              statusCode: 200,
              data: {'token': 'mock_token_123'},
            ));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) => AuthBloc(repository: repository),
          child: const LoginPage(),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField).first, 'test@test.com');
    await tester.enterText(find.byType(TextField).last, '1234');

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(); // show loading
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.textContaining('Login Success! Token'), findsOneWidget);
  });
}
