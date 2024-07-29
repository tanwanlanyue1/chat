import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/extension/date_time_extension.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/widgets/loading.dart';
import 'mine_gold_detail_state.dart';

class MineGoldDetailController extends GetxController {
  final MineGoldDetailState state = MineGoldDetailState();

  final pagingController = DefaultPagingController<WalletRecordRes>(
    refreshController: RefreshController()
  );

  void selectDate(int year, int month) {
    state.dateString.value = DateTime(year, month).formatYM;
    pagingController.refresh();
  }

  void onChangeTypeIndex(int index) {
    state.recordSelectType.value = index;
    pagingController.refresh();
  }

  void onChangeDealSelectIndex() {
    state.dealSelectType.value = state.dealSelectType.value == 0 ? 1 : 0;
    pagingController.refresh();
  }

  void _fetchPage(int page) async {
    final month = state.dateString.value;
    var type = state.recordSelectType.value;
    if (type == 1) {
      type = state.dealSelectType.value == 0 ? 1 : 2;
    }

    final res = await WalletApi.recordList(
      month: month,
      type: type,
      page: page,
      size: pagingController.pageSize,
    );

    if (res.isSuccess) {
      final amount = res.data?.amount ?? 0;

      if (state.recordSelectType.value == 1) {
        state.amountString =
            state.dealSelectType.value == 0 ? "总收益：$amount" : "总支出：$amount";
      } else {
        state.amountString = "";
      }

      final items = res.data?.list ?? [];
      pagingController.appendPageData(items);
    } else {
      pagingController.error = res.errorMessage;
    }
  }

  @override
  void onInit() async {
    state.dateString.value = DateTime.now().formatYM;

    pagingController.addPageRequestListener(_fetchPage);
    super.onInit();
  }

  @override
  void onClose() {
    pagingController.dispose();
    super.onClose();
  }
}
