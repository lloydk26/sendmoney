import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:send_money/core/storage/secure_storage_service.dart';
import 'package:send_money/features/auth/domain/entities/auth_entity.dart';
import 'package:send_money/features/auth/domain/services/auth_service.dart';
import 'package:send_money/features/auth/presentation/cubits/login_cubit.dart';
import 'package:send_money/features/auth/presentation/models/login_state.dart';

import 'login_cubit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AuthService>(),
  MockSpec<SecureStorageService>(),
])
void main() {
  late MockAuthService mockAuthService;
  late MockSecureStorageService mockSecureStorage;

  LoginCubit createUnitToTest() => LoginCubit(mockAuthService, mockSecureStorage);

  setUp(() {
    mockAuthService = MockAuthService();
    mockSecureStorage = MockSecureStorageService();
  });

  group('LoginCubit', () {
    test('login emits loading then success and stores token', () async {
      const entity = AuthEntity(
        status: 'success',
        accessToken: 'token-123',
      );
      final unit = createUnitToTest();

      when(mockAuthService.login('john', 'secret'))
          .thenAnswer((_) async => entity);
      when(mockSecureStorage.saveToken('token-123')).thenAnswer((_) async {});

      final expectation = expectLater(
        unit.stream,
        emitsInOrder([
          const LoginState.loading(),
          const LoginState.success(entity),
        ]),
      );
      await unit.login('john', 'secret');
      await expectation;

      verify(mockAuthService.login('john', 'secret')).called(1);
      verify(mockSecureStorage.saveToken('token-123')).called(1);
      await unit.close();
    });

    test('login emits loading then error when service fails', () async {
      final unit = createUnitToTest();

      when(mockAuthService.login('john', 'secret'))
          .thenThrow(Exception('Invalid credentials'));

      final expectation = expectLater(
        unit.stream,
        emitsInOrder([
          const LoginState.loading(),
          const LoginState.error('Invalid credentials'),
        ]),
      );
      await unit.login('john', 'secret');
      await expectation;

      verify(mockAuthService.login('john', 'secret')).called(1);
      verifyNever(mockSecureStorage.saveToken(any));
      await unit.close();
    });
  });
}
