import 'package:auto_mappr_annotation/auto_mappr_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../data/contracts/login_response_contract.dart';
import '../entities/auth_entity.dart';
import 'auth_mapper.auto_mappr.dart';

@AutoMappr([MapType<LoginResponseContract, AuthEntity>()])
@injectable
class AuthMapper extends $AuthMapper {}
