import 'package:injectable/injectable.dart';

@module
abstract class AppModule {
  @Named('appServerUrl')
  String get appServerUrl =>
      'https://sendpinoymoney.free.beeceptor.com';
}
