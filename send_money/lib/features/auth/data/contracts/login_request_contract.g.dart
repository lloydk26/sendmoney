// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_request_contract.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRequestContract _$LoginRequestContractFromJson(
  Map<String, dynamic> json,
) => LoginRequestContract(
  user: json['user'] as String,
  password: json['password'] as String,
);

Map<String, dynamic> _$LoginRequestContractToJson(
  LoginRequestContract instance,
) => <String, dynamic>{'user': instance.user, 'password': instance.password};
