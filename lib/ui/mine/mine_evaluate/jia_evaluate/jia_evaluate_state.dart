import 'package:get/get.dart';
import 'package:guanjia/common/service/service.dart';

import '../../../../common/network/api/api.dart';

class JiaEvaluateState {
  //我的标签
  final label = [].obs;

  final loginService = SS.login.info;
  //评价
  EvaluationListModel? evaluation;
}
