import 'package:json_annotation/json_annotation.dart';

part 'login_error_response_contract.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class LoginErrorDetailContract {
  const LoginErrorDetailContract({
    required this.code,
    required this.message,
  });

  factory LoginErrorDetailContract.fromJson(Map<String, dynamic> json) =>
      _$LoginErrorDetailContractFromJson(json);

  final String code;
  final String message;

  Map<String, dynamic> toJson() => _$LoginErrorDetailContractToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class LoginErrorResponseContract {
  const LoginErrorResponseContract({
    required this.status,
    required this.error,
  });

  factory LoginErrorResponseContract.fromJson(Map<String, dynamic> json) =>
      _$LoginErrorResponseContractFromJson(json);

  final String status;
  final LoginErrorDetailContract error;

  Map<String, dynamic> toJson() => _$LoginErrorResponseContractToJson(this);
}
