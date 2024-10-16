import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/network/api/model/user/message_model.dart';
import 'package:guanjia/common/network/api/payment_api.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../common/routes/app_pages.dart';
import 'wallet_order_list_state.dart';

class WalletOrderListController extends GetxController {
  ///1充值，2提现
  final int type;

  final WalletOrderListState state = WalletOrderListState();


  ///分页控制器
  late final pagingController = DefaultPagingController<WalletOrderItem>(
    pageSize: 20,
    refreshController: RefreshController(),
  )..addPageRequestListener((page){
    if(type == 1){
      _fetchRechargePage(page);
    }else{
      _fetchWithdrawPage(page);
    }
  });

  WalletOrderListController({required this.type});

  ///充值订单
  void _fetchRechargePage(int page) async {
    final response = await PaymentApi.getRechargeOrderList(
      page: page,
      size: pagingController.pageSize,
    );
    if (response.isSuccess) {
      final list = (response.data ?? []).map(WalletRechargeOrderItem.new).toList();
      pagingController.appendPageData(list);
    } else {
      pagingController.error = response.errorMessage;
    }
  }

  ///提现订单
  void _fetchWithdrawPage(int page) async {
    final response = await PaymentApi.getWithdrawOrderList(
      page: page,
      size: pagingController.pageSize,
    );
    if (response.isSuccess) {
      final list = (response.data ?? []).map(WalletWithdrawOrderItem.new).toList();
      pagingController.appendPageData(list);
    } else {
      pagingController.error = response.errorMessage;
    }
  }

  void onTapItem(WalletOrderItem item){
    ///充值
    if(item is WalletRechargeOrderItem && item.data.type == 0){
      Get.toNamed(AppRoutes.rechargeOrderPage, arguments: {
        'orderNo': item.data.orderNo,
      });
    }
  }

}
