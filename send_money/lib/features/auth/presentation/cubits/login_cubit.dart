import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/services/auth_service.dart';
import '../models/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(
    this._authService,
    this._secureStorage,
  ) : super(const LoginState.initial());

  final AuthService _authService;
  final SecureStorageService _secureStorage;

  Future<void> login(String user, String password) async {
    emit(const LoginState.loading());
    try {
      final AuthEntity entity = await _authService.login(user, password);
      await _secureStorage.saveToken(entity.accessToken);
      emit(LoginState.success(entity));
    } on Exception catch (e) {
      emit(LoginState.error(_messageFromException(e)));
    } catch (e) {
      emit(LoginState.error(e.toString()));
    }
  }

  String _messageFromException(Exception e) {
    final s = e.toString();
    const prefix = 'Exception: ';
    if (s.startsWith(prefix)) {
      return s.substring(prefix.length);
    }
    return s;
  }
}
