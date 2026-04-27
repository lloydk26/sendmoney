import 'package:json_annotation/json_annotation.dart';

part 'login_request_contract.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class LoginRequestContract {
  const LoginRequestContract({
    required this.user,
    required this.password,
  });

  factory LoginRequestContract.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestContractFromJson(json);

  final String user;
  final String password;

  Map<String, dynamic> toJson() => _$LoginRequestContractToJson(this);
}
