import 'package:dio/dio.dart' hide Headers;
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/dio_provider.dart';
import '../contracts/send_money_request_contract.dart';
import '../contracts/send_money_response_contract.dart';

part 'send_money_api.g.dart';

@lazySingleton
@RestApi()
abstract interface class SendMoneyApi {
  @factoryMethod
  factory SendMoneyApi(
    DioProvider dioProvider,
    @Named('appServerUrl') String baseUrl,
  ) => _SendMoneyApi(dioProvider.create<SendMoneyApi>(), baseUrl: baseUrl);

  @POST('/send-money')
  Future<SendMoneyResponseContract> sendMoney(
    @Header('Authorization') String authorization,
    @Body() SendMoneyRequestContract request,
  );
}
