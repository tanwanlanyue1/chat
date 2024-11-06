import 'package:get/get.dart';
import 'package:guanjia/common/event/event_bus.dart';
import 'package:guanjia/common/event/event_constant.dart';
import 'package:guanjia/common/extension/date_time_extension.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'wallet_record_filter_dialog.dart';

class WalletRecordController extends GetxController with GetAutoDisposeMixin {
  // 分页控制器
  final DefaultPagingController pagingController =
      DefaultPagingController<PurseLogModel>(
    refreshController: RefreshController(),
  );

  ///筛选项
  final filterDataRx = Rxn<RecordFilterData>();

  ///总收益
  final totalIncomeRx = RxNum(0);

  ///总支出
  final totalExpenditureRx = RxNum(0);

  @override
  void onInit() {
    pagingController.addPageRequestListener(_fetchPage);
    //充值到账成功时，筛选列表
    autoDisposeWorker(EventBus().listen(kEventRechargeSuccess, (data) {
      pagingController.refresh();
    }));
    super.onInit();
  }

  @override
  void onClose() {
    pagingController.dispose();
    super.onClose();
  }

  ///筛选
  void onTapFilter() async {
    final result = await WalletRecordFilterDialog.show(
      items: RecordType.getTypes(SS.login.userType),
      data: filterDataRx(),
    );
    if (result != null) {
      filterDataRx.value = result;
      pagingController.refresh();
    }
  }

  void _fetchPage(int page) async {
    final filterData = filterDataRx();
    final types = filterData?.types.map((e) => e.value).toList() ?? [];
    final startDate = filterData?.beginTime?.formatYMD;
    final endDate = filterData?.endTime?.lastDayOfMonth.formatYMD;
    final response = await UserApi.getPurseLogList(
      logType: types.isEmpty ? [-1] : types,
      startDate: startDate,
      endDate: endDate,
      page: page,
      size: pagingController.pageSize,
    );
    if (response.isSuccess) {
      final data = response.data;
      totalIncomeRx.value = data?.totalIncome ?? 0;
      totalExpenditureRx.value = data?.totalExpenditure ?? 0;
      pagingController.appendPageData(data?.list ?? []);
    } else {
      pagingController.error = response.errorMessage;
    }
  }
}

///记录类型 -1查询全部 1 充值 2.后台下发 3.后台扣减 4 订单保证金或服务费 5 通话实时扣费 6通话订单收益 7转账 8红包 9开通会员 12通话分成 13服务费分成
class RecordType {
  final int value;
  final String label;
  final List<UserType> roles;

  RecordType(this.value, this.label, this.roles);

  static List<RecordType> getTypes(UserType userType) {
    return _all.where((element) => element.roles.contains(userType)).toList();
  }

  ///是否是全部
  bool get isALl => value == -1;

  static List<RecordType> get _all {
    return [
      RecordType(-1, '全部', UserType.values),
      RecordType(1, '充值', UserType.values),
      // RecordType(2, '系统补偿', UserType.values),
      // RecordType(3, '系统扣除', UserType.values),
      RecordType(13, '服务费分成', [UserType.agent]),
      RecordType(12, '通话分成', [UserType.agent]),
      RecordType(4, '保证金或服务费', [UserType.user, UserType.beauty]),
      RecordType(5, '通话扣费', UserType.values),
      RecordType(6, '通话收益', UserType.values),
      RecordType(7, '转账', UserType.values),
      RecordType(8, '红包', UserType.values),
      RecordType(9, '开通会员', UserType.values),
    ];
  }
}
