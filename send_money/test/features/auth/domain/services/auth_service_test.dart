import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:send_money/features/auth/data/api/auth_api.dart';
import 'package:send_money/features/auth/data/contracts/login_request_contract.dart';
import 'package:send_money/features/auth/data/contracts/login_response_contract.dart';
import 'package:send_money/features/auth/domain/entities/auth_entity.dart';
import 'package:send_money/features/auth/domain/mapper/auth_mapper.dart';
import 'package:send_money/features/auth/domain/services/auth_service.dart';

import 'auth_service_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AuthApi>(),
])
void main() {
  late MockAuthApi mockAuthApi;
  late AuthMapper mapper;

  AuthService createUnitToTest() => AuthServiceImpl(mockAuthApi, mapper);

  setUp(() {
    mockAuthApi = MockAuthApi();
    mapper = AuthMapper();
  });

  group('AuthServiceImpl', () {
    test('login returns mapped auth entity when API succeeds', () async {
      const contract = LoginResponseContract(
        status: 'success',
        accessToken: 'token-123',
      );
      const expected = AuthEntity(
        status: 'success',
        accessToken: 'token-123',
      );
      final unit = createUnitToTest();

      when(mockAuthApi.login(any)).thenAnswer((_) async => contract);

      final result = await unit.login('john', 'secret');

      expect(result, expected);
      final capturedRequest =
          verify(mockAuthApi.login(captureAny)).captured.single
              as LoginRequestContract;
      expect(capturedRequest.user, 'john');
      expect(capturedRequest.password, 'secret');
    });

    test('login throws mapped API error message from DioException', () async {
      final requestOptions = RequestOptions(path: '/user/login');
      final unit = createUnitToTest();
      final exception = DioException(
        requestOptions: requestOptions,
        response: Response<Map<String, dynamic>>(
          requestOptions: requestOptions,
          data: {
            'status': 'error',
            'error': {
              'code': 'INVALID_CREDENTIALS',
              'message': 'Invalid credentials',
            },
          },
        ),
      );

      when(mockAuthApi.login(any)).thenThrow(exception);

      expect(
        () => unit.login('john', 'bad-password'),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            'Exception: Invalid credentials',
          ),
        ),
      );
    });
  });
}
