import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/dashboard/domain/entities/transaction_entity.dart';
import '../../features/dashboard/domain/entities/wallet_entity.dart';

@lazySingleton
class WalletCacheService {
  WalletCacheService(this._prefs);

  static const _cachedWalletKey = 'cached_wallet';

  final SharedPreferences _prefs;

  Future<void> saveWallet(WalletEntity wallet) async {
    final payload = <String, dynamic>{
      'balance': wallet.balance,
      'transactions': wallet.transactions
          .map(
            (transaction) => <String, dynamic>{
              'id': transaction.id,
              'date': transaction.date,
              'time': transaction.time,
              'accountName': transaction.accountName,
              'amount': transaction.amount,
              'type': transaction.type,
            },
          )
          .toList(),
    };

    await _prefs.setString(_cachedWalletKey, jsonEncode(payload));
  }

  WalletEntity? readWallet() {
    final raw = _prefs.getString(_cachedWalletKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        return null;
      }

      final transactionsJson =
          (decoded['transactions'] as List<dynamic>? ?? <dynamic>[]);
      final transactions = transactionsJson
          .whereType<Map<String, dynamic>>()
          .map(_transactionFromMap)
          .toList();

      return WalletEntity(
        balance: (decoded['balance'] as num?)?.toDouble() ?? 0,
        transactions: transactions,
      );
    } on FormatException {
      return null;
    } on TypeError {
      return null;
    }
  }

  Future<void> clear() => _prefs.remove(_cachedWalletKey);

  TransactionEntity _transactionFromMap(Map<String, dynamic> map) {
    return TransactionEntity(
      id: map['id'] as String? ?? '',
      date: map['date'] as String? ?? '',
      time: map['time'] as String? ?? '',
      accountName: map['accountName'] as String? ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0,
      type: map['type'] as String? ?? '',
    );
  }
}
