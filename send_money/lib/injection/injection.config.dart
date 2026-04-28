// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:send_money/core/cache/wallet_cache_service.dart' as _i36;
import 'package:send_money/core/network/app_module.dart' as _i185;
import 'package:send_money/core/network/dio_provider.dart' as _i81;
import 'package:send_money/core/storage/secure_storage_service.dart' as _i312;
import 'package:send_money/features/auth/data/api/auth_api.dart' as _i989;
import 'package:send_money/features/auth/domain/mapper/auth_mapper.dart'
    as _i696;
import 'package:send_money/features/auth/domain/services/auth_service.dart'
    as _i309;
import 'package:send_money/features/dashboard/data/api/dashboard_api.dart'
    as _i177;
import 'package:send_money/features/dashboard/domain/mapper/dashboard_mapper.dart'
    as _i524;
import 'package:send_money/features/dashboard/domain/services/dashboard_service.dart'
    as _i640;
import 'package:send_money/features/send_money/data/api/send_money_api.dart'
    as _i910;
import 'package:send_money/features/send_money/domain/mapper/send_money_mapper.dart'
    as _i1042;
import 'package:send_money/features/send_money/domain/services/send_money_service.dart'
    as _i217;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => appModule.prefs,
      preResolve: true,
    );
    gh.factory<_i696.AuthMapper>(() => _i696.AuthMapper());
    gh.factory<_i524.DashboardMapper>(() => _i524.DashboardMapper());
    gh.factory<_i1042.SendMoneyMapper>(() => _i1042.SendMoneyMapper());
    gh.lazySingleton<_i81.DioProvider>(() => _i81.DioProvider());
    gh.lazySingleton<_i312.SecureStorageService>(
      () => _i312.SecureStorageService(),
    );
    gh.factory<String>(
      () => appModule.appServerUrl,
      instanceName: 'appServerUrl',
    );
    gh.lazySingleton<_i989.AuthApi>(
      () => _i989.AuthApi(
        gh<_i81.DioProvider>(),
        gh<String>(instanceName: 'appServerUrl'),
      ),
    );
    gh.lazySingleton<_i177.DashboardApi>(
      () => _i177.DashboardApi(
        gh<_i81.DioProvider>(),
        gh<String>(instanceName: 'appServerUrl'),
      ),
    );
    gh.lazySingleton<_i910.SendMoneyApi>(
      () => _i910.SendMoneyApi(
        gh<_i81.DioProvider>(),
        gh<String>(instanceName: 'appServerUrl'),
      ),
    );
    gh.lazySingleton<_i217.SendMoneyService>(
      () => _i217.SendMoneyServiceImpl(
        gh<_i910.SendMoneyApi>(),
        gh<_i1042.SendMoneyMapper>(),
        gh<_i312.SecureStorageService>(),
      ),
    );
    gh.lazySingleton<_i36.WalletCacheService>(
      () => _i36.WalletCacheService(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i640.DashboardService>(
      () => _i640.DashboardServiceImpl(
        gh<_i177.DashboardApi>(),
        gh<_i524.DashboardMapper>(),
        gh<_i312.SecureStorageService>(),
      ),
    );
    gh.lazySingleton<_i309.AuthService>(
      () => _i309.AuthServiceImpl(gh<_i989.AuthApi>(), gh<_i696.AuthMapper>()),
    );
    return this;
  }
}

class _$AppModule extends _i185.AppModule {}
