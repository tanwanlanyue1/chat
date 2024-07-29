import 'package:get/get.dart';
import 'package:guanjia/common/extension/date_time_extension.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/widgets/loading.dart';
import 'mine_merit_virtue_state.dart';

class MineMeritVirtueController extends GetxController {
  final MineMeritVirtueState state = MineMeritVirtueState();

  final loginService = SS.login;

  static int firstPage = 1;

  final pagingController = DefaultPagingController<MeritVirtueLog>(
    firstPage: firstPage,
  );

  void onTapRanking() {
    Get.toNamed(AppRoutes.meritListPage);
  }

  void onTapMore() {
    Get.toNamed(AppRoutes.mineMissionCenter);
  }

  void selectDate(int year, int month) {
    state.dateString.value = DateTime(year, month).formatYM;
    pagingController.refresh();
  }

  void _fetchPage(int page) async {
    final month = state.dateString.value;
    if(page == 1){
      await _fetchIcons();
    }

    final res = await UserApi.getMeritVirtueList(
      month: month,
      page: page,
      size: pagingController.pageSize,
    );

    if (!res.isSuccess) {
      res.showErrorMessage();
    }

    if (res.isSuccess) {
      state.todayMav.value = res.data?.todayMav ?? 0;
      state.monthMav.value = res.data?.currentMav ?? 0;

      final items = res.data?.mavLog ?? [];
      pagingController.appendPageData(items);
    } else {
      pagingController.error = res.errorMessage;
    }
  }

  Future<void> _fetchIcons() async{
    final icons = SS.appConfig.configRx()?.logTypeIcon;
    if(icons == null){
      await SS.appConfig.fetchData();
    }
    SS.appConfig
        .configRx()
        ?.logTypeIcon
        ?.where((element) => element.icon.isNotEmpty)
        .forEach((element) {
      state.logTypeIconMap[element.logType] = element.icon;
    });
  }

  @override
  void onInit() async {
    loginService.fetchLevelMoneyInfo();
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
