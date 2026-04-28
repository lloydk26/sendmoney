import 'package:equatable/equatable.dart';

class TransactionEntity extends Equatable {
  const TransactionEntity({
    required this.id,
    required this.date,
    required this.time,
    required this.accountName,
    required this.amount,
    required this.type,
  });

  final String id;
  final String date;
  final String time;
  final String accountName;
  final double amount;
  final String type;

  @override
  List<Object?> get props => [id, date, time, accountName, amount, type];
}
