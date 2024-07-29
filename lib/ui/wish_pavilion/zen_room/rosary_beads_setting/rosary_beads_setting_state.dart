import 'package:guanjia/common/network/api/model/wish_pavilion/rosary_beads_product_model.dart';

class RosaryBeadsSettingState {

}


extension RosaryBeadsProductModelX on RosaryBeadsProductModel{

  ///是否需要购买才使用
  bool get isNeedBuy => purchase == 1 && isBuy == 0;
}