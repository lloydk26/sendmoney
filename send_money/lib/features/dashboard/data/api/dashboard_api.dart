import 'package:dio/dio.dart' hide Headers;
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/dio_provider.dart';
import '../contracts/wallet_response_contract.dart';

part 'dashboard_api.g.dart';

@lazySingleton
@RestApi()
abstract interface class DashboardApi {
  @factoryMethod
  factory DashboardApi(
    DioProvider dioProvider,
    @Named('appServerUrl') String baseUrl,
  ) => _DashboardApi(dioProvider.create<DashboardApi>(), baseUrl: baseUrl);

  @GET('/wallet/transaction-history')
  Future<WalletApiResponse> getWalletData(
    @Header('Authorization') String authorization,
  );
}
