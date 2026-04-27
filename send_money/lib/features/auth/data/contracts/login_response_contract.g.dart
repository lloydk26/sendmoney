// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response_contract.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponseContract _$LoginResponseContractFromJson(
  Map<String, dynamic> json,
) => LoginResponseContract(
  status: json['status'] as String,
  accessToken: json['access_token'] as String,
);

Map<String, dynamic> _$LoginResponseContractToJson(
  LoginResponseContract instance,
) => <String, dynamic>{
  'status': instance.status,
  'access_token': instance.accessToken,
};
