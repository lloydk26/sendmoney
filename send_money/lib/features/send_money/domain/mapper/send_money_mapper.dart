import 'package:auto_mappr_annotation/auto_mappr_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../data/contracts/send_money_response_contract.dart';
import '../entities/send_money_entity.dart';
import 'send_money_mapper.auto_mappr.dart';

@AutoMappr([MapType<SendMoneyResponseContract, SendMoneyEntity>()])
@injectable
class SendMoneyMapper extends $SendMoneyMapper {}
