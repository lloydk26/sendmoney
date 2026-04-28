import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:send_money/core/storage/secure_storage_service.dart';
import 'package:send_money/features/dashboard/domain/entities/transaction_entity.dart';
import 'package:send_money/features/dashboard/domain/entities/wallet_entity.dart';
import 'package:send_money/features/dashboard/domain/services/dashboard_service.dart';
import 'package:send_money/features/dashboard/presentation/cubits/dashboard_cubit.dart';
import 'package:send_money/features/dashboard/presentation/models/dashboard_state.dart';

import 'dashboard_cubit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<DashboardService>(),
  MockSpec<SecureStorageService>(),
])
void main() {
  late MockDashboardService mockDashboardService;
  late MockSecureStorageService mockSecureStorage;

  DashboardCubit createUnitToTest() =>
      DashboardCubit(mockDashboardService, mockSecureStorage);

  setUp(() {
    mockDashboardService = MockDashboardService();
    mockSecureStorage = MockSecureStorageService();
  });

  group('DashboardCubit', () {
    test('loadWalletData emits loading then success when service succeeds',
        () async {
      const wallet = WalletEntity(
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

      when(mockDashboardService.getWalletData())
          .thenAnswer((_) async => wallet);

      final expectation = expectLater(
        unit.stream,
        emitsInOrder([
          const DashboardState.loading(),
          const DashboardState.success(wallet),
        ]),
      );
      await unit.loadWalletData();
      await expectation;

      verify(mockDashboardService.getWalletData()).called(1);
      await unit.close();
    });

    test('loadWalletData emits loading then error when service fails', () async {
      final unit = createUnitToTest();

      when(mockDashboardService.getWalletData())
          .thenThrow(Exception('Cannot load wallet'));

      final expectation = expectLater(
        unit.stream,
        emitsInOrder([
          const DashboardState.loading(),
          const DashboardState.error('Cannot load wallet'),
        ]),
      );
      await unit.loadWalletData();
      await expectation;

      verify(mockDashboardService.getWalletData()).called(1);
      await unit.close();
    });

    test('logout deletes token then emits loggedOut', () async {
      final unit = createUnitToTest();

      when(mockSecureStorage.deleteToken()).thenAnswer((_) async {});

      final expectation = expectLater(
        unit.stream,
        emits(const DashboardState.loggedOut()),
      );
      await unit.logout();
      await expectation;

      verify(mockSecureStorage.deleteToken()).called(1);
      await unit.close();
    });

    test('logout throws when token deletion fails', () async {
      final unit = createUnitToTest();

      when(mockSecureStorage.deleteToken()).thenThrow(Exception('Storage error'));

      expect(() => unit.logout(), throwsA(isA<Exception>()));
      verify(mockSecureStorage.deleteToken()).called(1);

      await unit.close();
    });
  });
}
