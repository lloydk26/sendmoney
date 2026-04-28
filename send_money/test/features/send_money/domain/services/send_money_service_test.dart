import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:send_money/core/storage/secure_storage_service.dart';
import 'package:send_money/features/send_money/data/api/send_money_api.dart';
import 'package:send_money/features/send_money/data/contracts/send_money_request_contract.dart';
import 'package:send_money/features/send_money/data/contracts/send_money_response_contract.dart';
import 'package:send_money/features/send_money/domain/entities/send_money_entity.dart';
import 'package:send_money/features/send_money/domain/mapper/send_money_mapper.dart';
import 'package:send_money/features/send_money/domain/services/send_money_service.dart';

import 'send_money_service_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SendMoneyApi>(),
  MockSpec<SecureStorageService>(),
])
void main() {
  late MockSendMoneyApi mockSendMoneyApi;
  late SendMoneyMapper mapper;
  late MockSecureStorageService mockSecureStorage;

  SendMoneyService createUnitToTest() =>
      SendMoneyServiceImpl(mockSendMoneyApi, mapper, mockSecureStorage);

  setUp(() {
    mockSendMoneyApi = MockSendMoneyApi();
    mapper = SendMoneyMapper();
    mockSecureStorage = MockSecureStorageService();
  });

  group('SendMoneyServiceImpl', () {
    test('sendMoney returns mapped entity when API succeeds', () async {
      const contract = SendMoneyResponseContract(status: 'success');
      const expected = SendMoneyEntity(status: 'success');
      final unit = createUnitToTest();

      when(mockSecureStorage.getToken()).thenAnswer((_) async => 'token-123');
      when(mockSendMoneyApi.sendMoney('Bearer token-123', any))
          .thenAnswer((_) async => contract);

      final result = await unit.sendMoney(1234567890, 150.25);

      expect(result, expected);
      verify(mockSecureStorage.getToken()).called(1);
      final capturedRequest = verify(
        mockSendMoneyApi.sendMoney('Bearer token-123', captureAny),
      ).captured.single as SendMoneyRequestContract;
      expect(capturedRequest.accountNumber, 1234567890);
      expect(capturedRequest.amount, 150.25);
    });

    test('sendMoney throws mapped message on DioException', () async {
      final requestOptions = RequestOptions(path: '/send-money');
      final unit = createUnitToTest();
      final exception = DioException(
        requestOptions: requestOptions,
        message: 'Request timeout',
      );

      when(mockSecureStorage.getToken()).thenAnswer((_) async => 'token-123');
      when(mockSendMoneyApi.sendMoney('Bearer token-123', any))
          .thenThrow(exception);

      expect(
        () => unit.sendMoney(1234567890, 150.25),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            'Exception: Request timeout',
          ),
        ),
      );
    });
  });
}
