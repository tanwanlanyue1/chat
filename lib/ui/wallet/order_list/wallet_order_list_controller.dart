import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/network/api/model/user/message_model.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'wallet_order_list_state.dart';

class WalletOrderListController extends GetxController {
  ///1充值，2提现
  final int type;

  final WalletOrderListState state = WalletOrderListState();


  ///分页控制器
  late final pagingController = DefaultPagingController<MessageModel>(
    pageSize: 20,
    refreshController: RefreshController(),
  )..addPageRequestListener(fetchPage);

  WalletOrderListController({required this.type});

  void fetchPage(int page) async {
    final response = await UserApi.getMessageList(
      type: type,
      page: page,
      size: pagingController.pageSize,
    );
    if (response.isSuccess) {
      final list = response.data ?? [];
      pagingController.appendPageData(list);
    } else {
      pagingController.error = response.errorMessage;
    }
  }

  void onTapItem(){

  }

}
