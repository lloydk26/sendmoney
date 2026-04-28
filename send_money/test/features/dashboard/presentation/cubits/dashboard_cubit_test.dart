import 'package:send_money/core/cache/wallet_cache_service.dart';
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
  MockSpec<WalletCacheService>(),
])
void main() {
  late MockDashboardService mockDashboardService;
  late MockSecureStorageService mockSecureStorage;
  late MockWalletCacheService mockWalletCacheService;

  DashboardCubit createUnitToTest() => DashboardCubit(
    mockDashboardService,
    mockSecureStorage,
    mockWalletCacheService,
  );

  setUp(() {
    mockDashboardService = MockDashboardService();
    mockSecureStorage = MockSecureStorageService();
    mockWalletCacheService = MockWalletCacheService();
  });

  group('DashboardCubit', () {
    test(
      'loadWalletData emits loading then success when service succeeds',
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

        when(
          mockDashboardService.getWalletData(),
        ).thenAnswer((_) async => wallet);
        when(
          mockWalletCacheService.saveWallet(wallet),
        ).thenAnswer((_) async {});

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
        verify(mockWalletCacheService.saveWallet(wallet)).called(1);
        await unit.close();
      },
    );

    test(
      'loadWalletData emits loading then error when service fails',
      () async {
        final unit = createUnitToTest();

        when(
          mockDashboardService.getWalletData(),
        ).thenThrow(Exception('Cannot load wallet'));
        when(mockWalletCacheService.readWallet()).thenReturn(null);

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
        verify(mockWalletCacheService.readWallet()).called(1);
        await unit.close();
      },
    );

    test(
      'loadWalletData emits cached success when service fails offline',
      () async {
        const cachedWallet = WalletEntity(
          balance: 900,
          transactions: [
            TransactionEntity(
              id: 'cached-1',
              date: '2026-04-27',
              time: '10:00',
              accountName: 'Bob',
              amount: 50,
              type: 'debit',
            ),
          ],
        );
        final unit = createUnitToTest();

        when(
          mockDashboardService.getWalletData(),
        ).thenThrow(Exception('Cannot load wallet'));
        when(mockWalletCacheService.readWallet()).thenReturn(cachedWallet);

        final expectation = expectLater(
          unit.stream,
          emitsInOrder([
            const DashboardState.loading(),
            const DashboardState.success(cachedWallet),
          ]),
        );
        await unit.loadWalletData();
        await expectation;

        verify(mockDashboardService.getWalletData()).called(1);
        verify(mockWalletCacheService.readWallet()).called(1);
        await unit.close();
      },
    );

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

      when(
        mockSecureStorage.deleteToken(),
      ).thenThrow(Exception('Storage error'));

      expect(() => unit.logout(), throwsA(isA<Exception>()));
      verify(mockSecureStorage.deleteToken()).called(1);

      await unit.close();
    });
  });
}
