import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:send_money/core/storage/secure_storage_service.dart';
import 'package:send_money/features/dashboard/data/api/dashboard_api.dart';
import 'package:send_money/features/dashboard/data/contracts/transaction_contract.dart';
import 'package:send_money/features/dashboard/data/contracts/wallet_response_contract.dart';
import 'package:send_money/features/dashboard/domain/entities/transaction_entity.dart';
import 'package:send_money/features/dashboard/domain/entities/wallet_entity.dart';
import 'package:send_money/features/dashboard/domain/mapper/dashboard_mapper.dart';
import 'package:send_money/features/dashboard/domain/services/dashboard_service.dart';

import 'dashboard_service_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<DashboardApi>(),
  MockSpec<SecureStorageService>(),
])
void main() {
  late MockDashboardApi mockDashboardApi;
  late DashboardMapper mapper;
  late MockSecureStorageService mockSecureStorage;

  DashboardService createUnitToTest() =>
      DashboardServiceImpl(mockDashboardApi, mapper, mockSecureStorage);

  setUp(() {
    mockDashboardApi = MockDashboardApi();
    mapper = DashboardMapper();
    mockSecureStorage = MockSecureStorageService();
  });

  group('DashboardServiceImpl', () {
    test('getWalletData returns mapped wallet when API succeeds', () async {
      final contract = WalletResponseContract(
        balance: 1200,
        transactions: const [
          TransactionContract(
            id: '1',
            date: '2026-04-28',
            time: '12:00',
            accountName: 'Alice',
            amount: 100,
            type: 'credit',
          ),
        ],
      );
      final apiResponse = WalletApiResponse(data: contract);
      const expected = WalletEntity(
        balance: 1200,
        transactions: [
          TransactionEntity(
            id: '1',
            date: '2026-04-28',
            time: '12:00',
            accountName: 'Alice',
            amount: 100,
            type: 'credit',
          ),
        ],
      );
      final unit = createUnitToTest();

      when(mockSecureStorage.getToken()).thenAnswer((_) async => 'token-123');
      when(mockDashboardApi.getWalletData('Bearer token-123'))
          .thenAnswer((_) async => apiResponse);

      final result = await unit.getWalletData();

      expect(result, expected);
      verify(mockSecureStorage.getToken()).called(1);
      verify(mockDashboardApi.getWalletData('Bearer token-123')).called(1);
    });

    test('getWalletData throws mapped message on DioException', () async {
      final requestOptions = RequestOptions(path: '/wallet/transaction-history');
      final unit = createUnitToTest();
      final exception = DioException(
        requestOptions: requestOptions,
        message: 'Network error',
      );

      when(mockSecureStorage.getToken()).thenAnswer((_) async => 'token-123');
      when(mockDashboardApi.getWalletData('Bearer token-123'))
          .thenThrow(exception);

      expect(
        () => unit.getWalletData(),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            'Exception: Network error',
          ),
        ),
      );
    });
  });
}
