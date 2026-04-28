import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/send_money_entity.dart';

part 'send_money_state.freezed.dart';

@freezed
sealed class SendMoneyState with _$SendMoneyState {
  const factory SendMoneyState.initial() = _Initial;
  const factory SendMoneyState.loading() = _Loading;
  const factory SendMoneyState.success(
      SendMoneyEntity result, double amount) = _Success;
  const factory SendMoneyState.error(String message) = _Error;
}
