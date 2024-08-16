import 'package:get/get.dart';
import 'package:guanjia/common/event/event_bus.dart';
import 'package:guanjia/common/event/event_constant.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/network/api/model/user/contract_model.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'contract_list_state.dart';

class ContractListController extends GetxController with GetAutoDisposeMixin {
  final ContractListState state = ContractListState();

  //分页控制器
  final pagingController = DefaultPagingController<ContractModel>(
    firstPage: 1,
    pageSize: 10,
    refreshController: RefreshController(),
  );

  @override
  void onInit() {
    super.onInit();
    pagingController.addPageRequestListener(fetchPage);
    autoDisposeWorker(EventBus().listen(kEventContractUpdate, (data) {
      pagingController.refresh();
    }));
  }

  void fetchPage(int page) async {
    final response = await UserApi.listContract(page: page, size: pagingController.pageSize);
    if(response.isSuccess){
      pagingController.appendPageData(response.data ?? []);
    }else{
      pagingController.error = response.errorMessage;
    }
  }

}
