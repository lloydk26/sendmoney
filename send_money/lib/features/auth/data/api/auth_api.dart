import 'package:dio/dio.dart' hide Headers;
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/dio_provider.dart';
import '../contracts/login_request_contract.dart';
import '../contracts/login_response_contract.dart';

part 'auth_api.g.dart';

@lazySingleton
@RestApi()
abstract interface class AuthApi {
  @factoryMethod
  factory AuthApi(
    DioProvider dioProvider,
    @Named('appServerUrl') String baseUrl,
  ) =>
      _AuthApi(dioProvider.create<AuthApi>(), baseUrl: baseUrl);

  @POST('/user/login')
  Future<LoginResponseContract> login(@Body() LoginRequestContract request);
}