import 'package:get/get.dart';
import 'package:guanjia/common/network/api/model/user/contract_model.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'contract_list_state.dart';

class ContractListController extends GetxController {
  final ContractListState state = ContractListState();

  //分页控制器
  final pagingController = DefaultPagingController<ContractModel>(
    firstPage: 1,
    pageSize: 10,
    refreshController: RefreshController(),
  );

  @override
  void onInit() {
    pagingController.addPageRequestListener(fetchPage);
    super.onInit();
  }

  void fetchPage(int page) async {
    final items = [
      ContractModel(id: '2', broker: 'Alma Washington', date: '', status: 1),
      ContractModel(id: '3', broker: 'Amely', date: '2024/8/1', status: 2),
      ContractModel(id: '4', broker: 'CCC', date: '2023/12/1-2024/8/12', status: 3),
    ];
    pagingController.appendPageData(items);
  }

}
