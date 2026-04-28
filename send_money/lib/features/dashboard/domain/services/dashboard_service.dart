import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/storage/secure_storage_service.dart';
import '../../data/api/dashboard_api.dart';
import '../../data/contracts/wallet_response_contract.dart';
import '../entities/wallet_entity.dart';
import '../mapper/dashboard_mapper.dart';

abstract interface class DashboardService {
  Future<WalletEntity> getWalletData();
}

@LazySingleton(as: DashboardService)
class DashboardServiceImpl implements DashboardService {
  DashboardServiceImpl(
    this._dashboardApi,
    this._mapper,
    this._secureStorage,
  );

  final DashboardApi _dashboardApi;
  final DashboardMapper _mapper;
  final SecureStorageService _secureStorage;

  @override
  Future<WalletEntity> getWalletData() async {
    try {
      final token = await _secureStorage.getToken();
      final response = await _dashboardApi.getWalletData('Bearer $token');
      return _mapper.convert<WalletResponseContract, WalletEntity>(response.data);
    } on DioException catch (e) {
      throw Exception(_mapDioToMessage(e));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  String _mapDioToMessage(DioException e) {
    if (e.message != null && e.message!.isNotEmpty) return e.message!;
    return 'Something went wrong. Please try again.';
  }
}
