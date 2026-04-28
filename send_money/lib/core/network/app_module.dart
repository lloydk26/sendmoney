import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class AppModule {
  @Named('appServerUrl')
  String get appServerUrl => 'https://sendpinoymoney.free.beeceptor.com';

  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}
