import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/wallet_entity.dart';

part 'dashboard_state.freezed.dart';

@freezed
sealed class DashboardState with _$DashboardState {
  const factory DashboardState.initial() = _Initial;
  const factory DashboardState.loading() = _Loading;
  const factory DashboardState.success(WalletEntity wallet) = _Success;
  const factory DashboardState.error(String message) = _Error;
  const factory DashboardState.loggedOut() = _LoggedOut;
}
