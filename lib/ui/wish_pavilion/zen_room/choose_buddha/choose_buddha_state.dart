import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';

class ChooseBuddhaState {

  ///佛像列表
  final buddhaList = <BuddhaModel>[];

  ///已选中佛像的ID
  final selectedIdRx = 0.obs;

  ///已选中佛像的Index
  var selectedIndex = 0;


  ///已选中的佛像
  BuddhaModel? get selectedItemRx => buddhaList.firstWhereOrNull((element) => element.id == selectedIdRx.value);

  ///是否展开描述面板
  final isExpandedRx = false.obs;

}
