import 'package:equatable/equatable.dart';

import 'transaction_entity.dart';

class WalletEntity extends Equatable {
  const WalletEntity({
    required this.balance,
    required this.transactions,
  });

  final double balance;
  final List<TransactionEntity> transactions;

  @override
  List<Object?> get props => [balance, transactions];
}
