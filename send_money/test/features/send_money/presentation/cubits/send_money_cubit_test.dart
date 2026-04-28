import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:send_money/features/send_money/domain/entities/send_money_entity.dart';
import 'package:send_money/features/send_money/domain/services/send_money_service.dart';
import 'package:send_money/features/send_money/presentation/cubits/send_money_cubit.dart';
import 'package:send_money/features/send_money/presentation/models/send_money_state.dart';

import 'send_money_cubit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SendMoneyService>(),
])
void main() {
  late MockSendMoneyService mockSendMoneyService;

  SendMoneyCubit createUnitToTest() => SendMoneyCubit(mockSendMoneyService);

  setUp(() {
    mockSendMoneyService = MockSendMoneyService();
  });

  group('SendMoneyCubit', () {
    test('sendMoney emits loading then success when service succeeds', () async {
      const result = SendMoneyEntity(status: 'success');
      final unit = createUnitToTest();

      when(mockSendMoneyService.sendMoney(1234567890, 150.25))
          .thenAnswer((_) async => result);

      final expectation = expectLater(
        unit.stream,
        emitsInOrder([
          const SendMoneyState.loading(),
          const SendMoneyState.success(result, 150.25),
        ]),
      );
      await unit.sendMoney(1234567890, 150.25);
      await expectation;

      verify(mockSendMoneyService.sendMoney(1234567890, 150.25)).called(1);
      await unit.close();
    });

    test('sendMoney emits loading then error when service fails', () async {
      final unit = createUnitToTest();

      when(mockSendMoneyService.sendMoney(1234567890, 150.25))
          .thenThrow(Exception('Transfer failed'));

      final expectation = expectLater(
        unit.stream,
        emitsInOrder([
          const SendMoneyState.loading(),
          const SendMoneyState.error('Transfer failed'),
        ]),
      );
      await unit.sendMoney(1234567890, 150.25);
      await expectation;

      verify(mockSendMoneyService.sendMoney(1234567890, 150.25)).called(1);
      await unit.close();
    });
  });
}
