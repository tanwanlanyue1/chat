import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/ui/mine/widgets/archives_card.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

import 'mine_record_controller.dart';

///我的档案
class MineRecordPage extends StatelessWidget {
  MineRecordPage({Key? key}) : super(key: key);

  final controller = Get.put(MineRecordController());
  final state = Get.find<MineRecordController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("我的档案"),
        actions: [
          GestureDetector(
            onTap: controller.onTapToDetail,
            child: Container(
              margin: EdgeInsets.only(right: 12.rpx),
              child: AppImage.asset(
                "assets/images/mine/mine_add.png",
                width: 24.rpx,
                height: 24.rpx,
              ),
            ),
          )
        ],
      ),
      body: SmartRefresher(
        controller: controller.pagingController.refreshController,
        onRefresh: controller.pagingController.onRefresh,
        child: PagedListView(
          padding:
              EdgeInsets.symmetric(horizontal: 12.rpx).copyWith(top: 12.rpx),
          pagingController: controller.pagingController,
          builderDelegate: DefaultPagedChildBuilderDelegate<ArchivesInfo>(
            pagingController: controller.pagingController,
            itemBuilder: (
              _,
              info,
              index,
            ) {
              return ArchivesCard(
                data: info,
                archives: true,
                itemColor: Colors.white,
                callback: () {
                  controller.onTapToDetail(info: info);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
