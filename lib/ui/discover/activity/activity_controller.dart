import 'dart:convert';

import 'package:get/get.dart';
import 'package:guanjia/common/extension/string_extension.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/common/utils/app_link.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'activity_state.dart';

class ActivityController extends GetxController {
  final ActivityState state = ActivityState();

  //分页控制器
  final pagingController = DefaultPagingController<AdvertisingStartupModel>(
    firstPage: 1,
    pageSize: 10,
    refreshController: RefreshController(),
  );

  @override
  void onInit() {
    // TODO: implement onInit
    pagingController.addPageRequestListener(fetchPage);
    super.onInit();
  }

  ///获取全部活动
  void fetchPage(int page) async {
    final response = await OpenApi.getAdList();
    if (response.isSuccess) {
      final items = response.data ?? [];
      pagingController.appendPageData(items);
    } else {
      pagingController.error = response.errorMessage;
    }
  }

  //活动
  void onTapAdvertising(AdvertisingStartupModel item) {
    final url = item.gotoUrl;
    if(url != null){
      AppLink.jump(
          url,
          title: item.title,
          args: item.gotoParam?.toJson(),
      );
    }
  }
}
