import 'package:json_annotation/json_annotation.dart';

part 'login_response_contract.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class LoginResponseContract {
  const LoginResponseContract({
    required this.status,
    required this.accessToken,
  });

  factory LoginResponseContract.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseContractFromJson(json);

  final String status;
  final String accessToken;

  Map<String, dynamic> toJson() => _$LoginResponseContractToJson(this);
}
