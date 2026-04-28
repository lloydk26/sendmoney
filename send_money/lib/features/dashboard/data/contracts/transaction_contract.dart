import 'package:json_annotation/json_annotation.dart';

part 'transaction_contract.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TransactionContract {
  const TransactionContract({
    required this.id,
    required this.date,
    required this.time,
    required this.accountName,
    required this.amount,
    required this.type,
  });

  factory TransactionContract.fromJson(Map<String, dynamic> json) =>
      _$TransactionContractFromJson(json);

  final String id;
  final String date;
  final String time;
  final String accountName;
  final double amount;
  final String type;

  Map<String, dynamic> toJson() => _$TransactionContractToJson(this);
}
