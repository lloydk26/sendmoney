import 'package:json_annotation/json_annotation.dart';

import 'transaction_contract.dart';

part 'wallet_response_contract.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class WalletResponseContract {
  const WalletResponseContract({
    required this.balance,
    required this.transactions,
  });

  factory WalletResponseContract.fromJson(Map<String, dynamic> json) =>
      _$WalletResponseContractFromJson(json);

  final double balance;
  final List<TransactionContract> transactions;
}

@JsonSerializable(fieldRename: FieldRename.snake)
class WalletApiResponse {
  const WalletApiResponse({required this.data});

  factory WalletApiResponse.fromJson(Map<String, dynamic> json) =>
      _$WalletApiResponseFromJson(json);

  final WalletResponseContract data;
}
