import 'package:json_annotation/json_annotation.dart';

part 'send_money_request_contract.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SendMoneyRequestContract {
  const SendMoneyRequestContract({
    required this.accountNumber,
    required this.amount,
  });

  factory SendMoneyRequestContract.fromJson(Map<String, dynamic> json) =>
      _$SendMoneyRequestContractFromJson(json);

  @JsonKey(name: 'account-number')
  final int accountNumber;
  final double amount;

  Map<String, dynamic> toJson() => _$SendMoneyRequestContractToJson(this);
}
