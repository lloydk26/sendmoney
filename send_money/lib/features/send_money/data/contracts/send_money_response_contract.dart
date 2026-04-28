import 'package:json_annotation/json_annotation.dart';

part 'send_money_response_contract.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SendMoneyResponseContract {
  const SendMoneyResponseContract({required this.status});

  factory SendMoneyResponseContract.fromJson(Map<String, dynamic> json) =>
      _$SendMoneyResponseContractFromJson(json);

  final String status;
}
