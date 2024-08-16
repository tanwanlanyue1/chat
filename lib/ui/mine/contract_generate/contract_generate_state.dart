import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/network/api/model/user/contract_model.dart';

class ContractGenerateState {

  ///合约模板
  final templateRx = Rxn<ContractModel>();

  ///佳丽列表
  final beautyListRx = <UserModel>[].obs;

  ///已选择的佳丽
  final selectedBeautyRx = Rxn<UserModel>();

}
