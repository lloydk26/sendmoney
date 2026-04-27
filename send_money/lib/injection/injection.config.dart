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
import 'package:send_money/core/di/app_module.dart' as _i723;
import 'package:send_money/core/network/dio_provider.dart' as _i81;
import 'package:send_money/core/storage/secure_storage_service.dart' as _i312;
import 'package:send_money/features/auth/data/api/auth_api.dart' as _i989;
import 'package:send_money/features/auth/domain/mapper/auth_mapper.dart'
    as _i696;
import 'package:send_money/features/auth/domain/services/auth_service.dart'
    as _i309;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    gh.factory<_i696.AuthMapper>(() => _i696.AuthMapper());
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
    gh.lazySingleton<_i309.AuthService>(
      () => _i309.AuthServiceImpl(gh<_i989.AuthApi>(), gh<_i696.AuthMapper>()),
    );
    return this;
  }
}

class _$AppModule extends _i723.AppModule {}
