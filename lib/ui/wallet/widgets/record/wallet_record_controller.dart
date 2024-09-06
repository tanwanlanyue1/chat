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
import 'package:guanjia/widgets/loading.dart';

class WalletRecordController extends GetxController {
  // 分页控制器
  final DefaultPagingController pagingController =
      DefaultPagingController<PurseLogList>();

  final logType = RxInt(-1);
  final logTypeName = "全部".obs;

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

  void onTapStyle() {
    final types = SS.appConfig.configRx.value?.logTypeIcon ?? [];
    if (types.isEmpty) {
      Loading.showToast("数据错误");
      return;
    }

    Get.bottomSheet(
      isScrollControlled: true,
      Container(
        padding: EdgeInsets.symmetric(horizontal: 16.rpx, vertical: 24.rpx)
            .copyWith(bottom: 24.rpx + Get.mediaQuery.padding.bottom),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.rpx),
            topRight: Radius.circular(8.rpx),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "快捷筛选",
                  style: AppTextStyle.st.bold
                      .size(16.rpx)
                      .textColor(AppColor.blackBlue),
                ),
                GestureDetector(
                  onTap: Get.back,
                  child: Icon(
                    Icons.close,
                    size: 24.rpx,
                    color: AppColor.black3,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.rpx),
            SizedBox(
              child: Wrap(
                spacing: 8.rpx,
                runSpacing: 8.rpx,
                children: List.generate(
                  types.length,
                  (index) {
                    final type = types[index];
                    return GestureDetector(
                      onTap: () {
                        logType.value = type.logType;
                        logTypeName.value = type.name;
                        pagingController.refresh();

                        Get.back();
                      },
                      child: Container(
                        height: 40.rpx,
                        decoration: BoxDecoration(
                          color: AppColor.background,
                          borderRadius: BorderRadius.circular(8.rpx),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16.rpx),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              type.name,
                              style: AppTextStyle.st
                                  .size(14.rpx)
                                  .textColor(AppColor.black3),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _fetchPage(int page) async {
    final res = await UserApi.getPurseLogList(logType: logType.value);

    if (res.isSuccess) {
      final listSubModel = res.data ?? [];
      pagingController.appendPageData(listSubModel);
    } else {
      pagingController.error = res.errorMessage;
    }
  }
}
