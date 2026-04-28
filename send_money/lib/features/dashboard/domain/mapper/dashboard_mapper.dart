import 'package:auto_mappr_annotation/auto_mappr_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../data/contracts/transaction_contract.dart';
import '../../data/contracts/wallet_response_contract.dart';
import '../entities/transaction_entity.dart';
import '../entities/wallet_entity.dart';
import 'dashboard_mapper.auto_mappr.dart';

@AutoMappr([
  MapType<TransactionContract, TransactionEntity>(),
  MapType<WalletResponseContract, WalletEntity>(),
])
@injectable
class DashboardMapper extends $DashboardMapper {}
