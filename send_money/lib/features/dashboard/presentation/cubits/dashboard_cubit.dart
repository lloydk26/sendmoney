import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cache/wallet_cache_service.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/services/dashboard_service.dart';
import '../models/dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(
    this._dashboardService,
    this._secureStorage,
    this._walletCacheService,
  ) : super(const DashboardState.initial());

  final DashboardService _dashboardService;
  final SecureStorageService _secureStorage;
  final WalletCacheService _walletCacheService;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;

  Future<void> loadWalletData() async {
    emit(const DashboardState.loading());
    try {
      final wallet = await _dashboardService.getWalletData();
      await _walletCacheService.saveWallet(wallet);
      emit(DashboardState.success(wallet));
    } catch (e) {
      final cached = _walletCacheService.readWallet();
      if (cached != null) {
        emit(DashboardState.success(cached));
        return;
      }

      if (e is Exception) {
        emit(DashboardState.error(_messageFromException(e)));
        return;
      }

      emit(DashboardState.error(e.toString()));
    }
  }

  void listenToConnectivity() {
    _connectivitySub ??= Connectivity().onConnectivityChanged.listen((results) {
      final isOnline = results.any((r) => r != ConnectivityResult.none);
      if (isOnline) {
        loadWalletData();
      }
    });
  }

  Future<void> logout() async {
    await _secureStorage.deleteToken();
    emit(const DashboardState.loggedOut());
  }

  @override
  Future<void> close() {
    _connectivitySub?.cancel();
    return super.close();
  }

  String _messageFromException(Exception e) {
    final s = e.toString();
    const prefix = 'Exception: ';
    return s.startsWith(prefix) ? s.substring(prefix.length) : s;
  }
}
