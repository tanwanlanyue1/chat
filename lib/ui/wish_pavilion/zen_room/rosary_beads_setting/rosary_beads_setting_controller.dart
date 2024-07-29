import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/network/api/model/wish_pavilion/rosary_beads_product_model.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:guanjia/widgets/widgets.dart';

import 'rosary_beads_setting_state.dart';

class RosaryBeadsSettingController extends GetxController {
  final RosaryBeadsSettingState state = RosaryBeadsSettingState();

  ///当前使用的背景ID
  final int? currentBackgroundId;
  RosaryBeadsSettingController(this.currentBackgroundId);

  late final pagingController =
      DefaultPagingController<RosaryBeadsProductModel>.single()
        ..addPageRequestListener(_fetchData);

  void _fetchData(_) async {
    final response = await WishPavilionApi.getRosaryBeadsProductList(1);
    if(response.isSuccess){
      pagingController.appendPageData(response.data ?? []);
    }else{
      pagingController.error = response.errorMessage;
    }
  }

  void onTapItem(RosaryBeadsProductModel item) async{
    if(item.isNeedBuy){
      Loading.show();
      final response = await WishPavilionApi.buyRosaryBeadsProduct(item.id);
      Loading.dismiss();
      if(!response.isSuccess){
        response.showErrorMessage();
        return;
      }
      item = item.copyWith(isBuy: 1);
      Loading.showToast('购买成功');
      //刷新余额
      SS.login.fetchLevelMoneyInfo();
    }
    Get.back(result: item);
  }
}
