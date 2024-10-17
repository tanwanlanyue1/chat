import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/common_bottom_sheet.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'wallet_record_filter_dialog.dart';

class WalletRecordController extends GetxController {
  // 分页控制器
  final DefaultPagingController pagingController =
      DefaultPagingController<PurseLogList>(
    refreshController: RefreshController(),
  );

  final recordTypeRx = Rxn<RecordType>();

  @override
  void onInit() {
    pagingController.addPageRequestListener(_fetchPage);
    super.onInit();
  }

  @override
  void onClose() {
    pagingController.dispose();
    super.onClose();
  }

  ///筛选
  void onTapFilter() async {
    final type = await WalletRecordFilterDialog.show(items: RecordType.getTypes(SS.login.userType));
    if (type != null && type.value != recordTypeRx()?.value) {
      recordTypeRx.value = type;
      pagingController.refresh();
    }
  }

  void _fetchPage(int page) async {
    final res =
        await UserApi.getPurseLogList(logType: recordTypeRx()?.value ?? -1);
    if (res.isSuccess) {
      final listSubModel = res.data ?? [];
      pagingController.appendPageData(listSubModel);
    } else {
      pagingController.error = res.errorMessage;
    }
  }
}

///记录类型 -1查询全部 1 充值 2.后台下发 3.后台扣减 4 订单保证金或服务费 5 通话实时扣费 6通话订单收益 7转账 8红包 9开通会员 12通话分成 13服务费分成
class RecordType {
  final int value;
  final String label;
  final List<UserType> roles;

  RecordType(this.value, this.label, this.roles);

  static List<RecordType> getTypes(UserType userType){
    return _all.where((element) => element.roles.contains(userType)).toList();
  }

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
