import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  const AuthEntity({
    required this.status,
    required this.accessToken,
  });

  final String status;
  final String accessToken;

  @override
  List<Object?> get props => [status, accessToken];
}
