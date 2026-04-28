import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/storage/secure_storage_service.dart';
import '../../data/api/send_money_api.dart';
import '../../data/contracts/send_money_request_contract.dart';
import '../../data/contracts/send_money_response_contract.dart';
import '../entities/send_money_entity.dart';
import '../mapper/send_money_mapper.dart';

abstract interface class SendMoneyService {
  Future<SendMoneyEntity> sendMoney(int accountNumber, double amount);
}

@LazySingleton(as: SendMoneyService)
class SendMoneyServiceImpl implements SendMoneyService {
  SendMoneyServiceImpl(
    this._sendMoneyApi,
    this._mapper,
    this._secureStorage,
  );

  final SendMoneyApi _sendMoneyApi;
  final SendMoneyMapper _mapper;
  final SecureStorageService _secureStorage;

  @override
  Future<SendMoneyEntity> sendMoney(int accountNumber, double amount) async {
    try {
      final token = await _secureStorage.getToken();
      final request = SendMoneyRequestContract(
        accountNumber: accountNumber,
        amount: amount,
      );
      final response = await _sendMoneyApi.sendMoney('Bearer $token', request);
      return _mapper.convert<SendMoneyResponseContract, SendMoneyEntity>(
          response);
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
