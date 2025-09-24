import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:new_boilerplate/features/auth/bloc/auth_bloc.dart';
import '../mocks/auth_repository_test.mocks.dart';

void main() {
  late MockAuthRepository mockRepo;
  late AuthBloc authBloc;

  setUp(() {
    mockRepo = MockAuthRepository();
    authBloc = AuthBloc(repo: mockRepo);
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc Unit Test', () {
    test('emits [AuthLoading, AuthSuccess] on successful login', () async {
      when(mockRepo.login('Ajay', '1234'))
          .thenAnswer((_) async => 'Welcome Ajay (mockito)');

      authBloc.add(LoginRequested('Ajay', '1234'));

      await expectLater(
        authBloc.stream,
        emitsInOrder([
          isA<AuthLoading>(),
          isA<AuthSuccess>()
              .having((s) => s.message, 'message', 'Welcome Ajay (mockito)'),
        ]),
      );
      verify(mockRepo.login('Ajay', '1234')).called(1);
    });
  });
}
