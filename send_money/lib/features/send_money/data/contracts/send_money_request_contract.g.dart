// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_money_request_contract.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendMoneyRequestContract _$SendMoneyRequestContractFromJson(
  Map<String, dynamic> json,
) => SendMoneyRequestContract(
  accountNumber: (json['account-number'] as num).toInt(),
  amount: (json['amount'] as num).toDouble(),
);

Map<String, dynamic> _$SendMoneyRequestContractToJson(
  SendMoneyRequestContract instance,
) => <String, dynamic>{
  'account-number': instance.accountNumber,
  'amount': instance.amount,
};
