import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/services/send_money_service.dart';
import '../models/send_money_state.dart';

class SendMoneyCubit extends Cubit<SendMoneyState> {
  SendMoneyCubit(this._sendMoneyService) : super(const SendMoneyState.initial());

  final SendMoneyService _sendMoneyService;

  Future<void> sendMoney(int accountNumber, double amount) async {
    emit(const SendMoneyState.loading());
    try {
      final result = await _sendMoneyService.sendMoney(accountNumber, amount);
      emit(SendMoneyState.success(result, amount));
    } on Exception catch (e) {
      emit(SendMoneyState.error(_messageFromException(e)));
    } catch (e) {
      emit(SendMoneyState.error(e.toString()));
    }
  }

  String _messageFromException(Exception e) {
    final s = e.toString();
    const prefix = 'Exception: ';
    return s.startsWith(prefix) ? s.substring(prefix.length) : s;
  }
}
