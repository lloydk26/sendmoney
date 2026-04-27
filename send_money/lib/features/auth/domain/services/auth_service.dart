import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../data/api/auth_api.dart';
import '../../data/contracts/login_error_response_contract.dart';
import '../../data/contracts/login_request_contract.dart';
import '../../data/contracts/login_response_contract.dart';
import '../entities/auth_entity.dart';
import '../mapper/auth_mapper.dart';

abstract interface class AuthService {
  Future<AuthEntity> login(String user, String password);
}

@LazySingleton(as: AuthService)
class AuthServiceImpl implements AuthService {
  AuthServiceImpl(this._authApi, this._mapper);

  final AuthApi _authApi;
  final AuthMapper _mapper;

  @override
  Future<AuthEntity> login(String user, String password) async {
    final request = LoginRequestContract(user: user, password: password);
    try {
      final contract = await _authApi.login(request);
      return _mapper.convert<LoginResponseContract, AuthEntity>(contract);
    } on DioException catch (e) {
      throw Exception(_mapDioToMessage(e));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  String _mapDioToMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      try {
        final err = LoginErrorResponseContract.fromJson(data);
        return err.error.message;
      } catch (_) {}
    }
    if (e.message != null && e.message!.isNotEmpty) {
      return e.message!;
    }
    return 'Something went wrong. Please try again.';
  }
}
