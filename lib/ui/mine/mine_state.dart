import 'package:get/get.dart';
import 'package:guanjia/common/extension/functions_extension.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/generated/l10n.dart';

import '../../common/network/api/api.dart';
import 'widgets/beautiful_status_switch.dart';

class MineState {

  ///佳丽状态
  UserStatus? get beautifulStatusRx => SS.login.info?.state;

}
