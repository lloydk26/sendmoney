// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_response_contract.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletResponseContract _$WalletResponseContractFromJson(
  Map<String, dynamic> json,
) => WalletResponseContract(
  balance: (json['balance'] as num).toDouble(),
  transactions: (json['transactions'] as List<dynamic>)
      .map((e) => TransactionContract.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$WalletResponseContractToJson(
  WalletResponseContract instance,
) => <String, dynamic>{
  'balance': instance.balance,
  'transactions': instance.transactions,
};

WalletApiResponse _$WalletApiResponseFromJson(Map<String, dynamic> json) =>
    WalletApiResponse(
      data: WalletResponseContract.fromJson(
        json['data'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$WalletApiResponseToJson(WalletApiResponse instance) =>
    <String, dynamic>{'data': instance.data};
