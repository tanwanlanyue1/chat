import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../common/network/api/api.dart';
import 'activity_controller.dart';

//发现-热门活动
class ActivityPage extends StatelessWidget {
  ActivityPage({Key? key}) : super(key: key);

  final controller = Get.put(ActivityController());
  final state = Get.find<ActivityController>().state;

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: controller.pagingController.refreshController,
      onRefresh: controller.pagingController.onRefresh,
      child: PagedListView(
        pagingController: controller.pagingController,
        padding: EdgeInsets.all(16.rpx),
        builderDelegate: DefaultPagedChildBuilderDelegate<AdvertisingStartupModel>(
          pagingController: controller.pagingController,
          itemBuilder: (_, item, index) {
            return GestureDetector(
              onTap: ()=> controller.onTapAdvertising(item),
              child: Padding(
                padding: EdgeInsets.only(bottom: 16.rpx),
                child: AppImage.network(
                  item.image ?? "",
                  height: 170.rpx,
                  borderRadius: BorderRadius.circular(8.rpx),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
