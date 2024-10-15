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

import 'wallet_record_filter_dialog.dart';

class WalletRecordController extends GetxController {
  // 分页控制器
  final DefaultPagingController pagingController =
      DefaultPagingController<PurseLogList>();

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
  void onTapFilter() async{
    final type = await WalletRecordFilterDialog.show(items: RecordType.all);
    if(type != null && type.value != recordTypeRx()?.value){
      recordTypeRx.value = type;
      pagingController.refresh();
    }
  }

  void _fetchPage(int page) async {
    final res = await UserApi.getPurseLogList(logType: recordTypeRx()?.value ?? -1);
    if (res.isSuccess) {
      final listSubModel = res.data ?? [];
      pagingController.appendPageData(listSubModel);
    } else {
      pagingController.error = res.errorMessage;
    }
  }
}

///记录类型 -1查询全部 1 充值 2.后台下发 3.后台扣减 4 订单保证金或服务费 5 通话实时扣费 6通话订单收益 7转账 8红包
class RecordType{
  final int value;
  final String label;
  RecordType(this.value, this.label);

  static List<RecordType> get all{
    return [
      RecordType(-1, '全部'),
      RecordType(2, '后台下发'),
      RecordType(3, '后台扣减'),
      RecordType(4, '保证金或服务费'),
      RecordType(5, '通话扣费'),
      RecordType(6, '通话收益'),
      RecordType(8, '红包'),
    ];
  }
}
