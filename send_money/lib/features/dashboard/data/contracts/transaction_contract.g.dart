// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_contract.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionContract _$TransactionContractFromJson(Map<String, dynamic> json) =>
    TransactionContract(
      id: json['id'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      accountName: json['account_name'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] as String,
    );

Map<String, dynamic> _$TransactionContractToJson(
  TransactionContract instance,
) => <String, dynamic>{
  'id': instance.id,
  'date': instance.date,
  'time': instance.time,
  'account_name': instance.accountName,
  'amount': instance.amount,
  'type': instance.type,
};
