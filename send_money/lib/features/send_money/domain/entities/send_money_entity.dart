import 'package:equatable/equatable.dart';

class SendMoneyEntity extends Equatable {
  const SendMoneyEntity({required this.status});

  final String status;

  @override
  List<Object?> get props => [status];
}
