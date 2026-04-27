// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_error_response_contract.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginErrorDetailContract _$LoginErrorDetailContractFromJson(
  Map<String, dynamic> json,
) => LoginErrorDetailContract(
  code: json['code'] as String,
  message: json['message'] as String,
);

Map<String, dynamic> _$LoginErrorDetailContractToJson(
  LoginErrorDetailContract instance,
) => <String, dynamic>{'code': instance.code, 'message': instance.message};

LoginErrorResponseContract _$LoginErrorResponseContractFromJson(
  Map<String, dynamic> json,
) => LoginErrorResponseContract(
  status: json['status'] as String,
  error: LoginErrorDetailContract.fromJson(
    json['error'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$LoginErrorResponseContractToJson(
  LoginErrorResponseContract instance,
) => <String, dynamic>{'status': instance.status, 'error': instance.error};
