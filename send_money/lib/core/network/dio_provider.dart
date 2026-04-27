import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DioProvider {
  DioProvider() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: const {'Content-Type': 'application/json'},
      ),
    );
  }

  late final Dio _dio;

  Dio create<T>() => _dio;
}
