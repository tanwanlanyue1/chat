import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';

import '../../../common/network/api/model/talk_model.dart';
import 'plaza_history_controller.dart';
import 'widgets/plaza_history_list_item.dart';

///广场浏览历史
class PlazaHistoryPage extends StatelessWidget {
  PlazaHistoryPage({Key? key}) : super(key: key);

  final controller = Get.put(PlazaHistoryController());
  final state = Get.find<PlazaHistoryController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF6F8FE),
        appBar: AppBar(
          title: Text(
            "浏览记录",
            style: TextStyle(color: const Color(0xff333333), fontSize: 18.rpx),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: controller.cleanHistory,
              child: Container(
                margin: EdgeInsets.only(right: 12.rpx),
                child: AppImage.asset(
                  "assets/images/mine/message_session_delete.png",
                  width: 20.rpx,
                  height: 20.rpx,
                ),
              ),
            )
          ],
        ),
        body: GetBuilder<PlazaHistoryController>(builder: (_) {
          return SafeArea(
            child: SmartRefresher(
              controller: controller.pagingController.refreshController,
              onRefresh: controller.pagingController.onRefresh,
              child: PagedListView(
                  pagingController: controller.pagingController,
                  builderDelegate:
                      DefaultPagedChildBuilderDelegate<PlazaListModel>(
                          pagingController: controller.pagingController,
                          itemBuilder: (_, item, index) {
                            return PlazaHistoryListItem(
                              item: item,
                              prevItem: controller.pagingController.itemList
                                  ?.tryGet(index - 1),
                              onDelete: () => controller.deleteItem(item),
                              isCollect: (collect) {
                                controller.getCommentCollect(collect, index);
                              },
                              isLike: (like) {
                                controller.getCommentLike(like, index);
                              },
                            );
                          })),
            ),
          );
        }));
  }
}
