import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/services/dashboard_service.dart';
import '../models/dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(
    this._dashboardService,
    this._secureStorage,
  ) : super(const DashboardState.initial());

  final DashboardService _dashboardService;
  final SecureStorageService _secureStorage;

  Future<void> loadWalletData() async {
    emit(const DashboardState.loading());
    try {
      final wallet = await _dashboardService.getWalletData();
      emit(DashboardState.success(wallet));
    } on Exception catch (e) {
      emit(DashboardState.error(_messageFromException(e)));
    } catch (e) {
      emit(DashboardState.error(e.toString()));
    }
  }

  Future<void> logout() async {
    await _secureStorage.deleteToken();
    emit(const DashboardState.loggedOut());
  }

  String _messageFromException(Exception e) {
    final s = e.toString();
    const prefix = 'Exception: ';
    return s.startsWith(prefix) ? s.substring(prefix.length) : s;
  }
}
