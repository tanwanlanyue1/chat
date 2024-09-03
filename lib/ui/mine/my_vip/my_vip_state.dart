import 'package:get/get.dart';
import 'package:guanjia/common/network/api/model/user/vip_model.dart';

class MyVipState {
  final vipModel = Rxn<VipModel>();

  final packagesIndex = 0.obs;

  final selectProtocol = true.obs;
}
