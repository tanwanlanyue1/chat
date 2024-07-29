import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

import 'mine_attention_controller.dart';

///我的-关注
class MineAttentionPage extends StatelessWidget {
  MineAttentionPage({Key? key}) : super(key: key);

  final controller = Get.put(MineAttentionController());
  final state = Get.find<MineAttentionController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F8FE),
      // appBar: AppBar(
      //   title: const Text("我的关注"),
      // ),
      body: SmartRefresher(
        controller: controller.pagingController.refreshController,
        onRefresh: controller.pagingController.onRefresh,
        child: PagedListView(
          padding:
              EdgeInsets.symmetric(horizontal: 12.rpx).copyWith(top: 12.rpx),
          pagingController: controller.pagingController,
          builderDelegate: DefaultPagedChildBuilderDelegate<UserModel>(
            pagingController: controller.pagingController,
            itemBuilder: (
              _,
              model,
              index,
            ) {
              return buildItem(model, index: index);
            },
          ),
        ),
      ),
    );
  }

  Widget buildItem(UserModel model, {required int index}) {
    final star = model.star ?? "";

    return GestureDetector(
      onTap: () => controller.onTapItem(model.uid),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: index == 0
              ? BorderRadius.only(
                  topLeft: Radius.circular(8.rpx),
                  topRight: Radius.circular(8.rpx),
                )
              : BorderRadius.zero,
        ),
        height: 56.rpx,
        margin: EdgeInsets.only(bottom: 1.rpx),
        padding: EdgeInsets.all(12.rpx),
        child: Row(
          children: [
            AppImage.network(
              model.avatar ?? "",
              width: 32.rpx,
              height: 32.rpx,
              shape: BoxShape.circle,
            ),
            SizedBox(width: 8.rpx),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          model.nickname ?? "",
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 12.rpx, color: const Color(0xff333333)),
                        ),
                      ),
                      Visibility(
                        visible: star.isNotEmpty,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xff8D310F),
                            borderRadius: BorderRadius.all(
                              Radius.circular(2.rpx),
                            ),
                          ),
                          margin: EdgeInsets.only(left: 8.rpx),
                          padding: EdgeInsets.only(left: 4.rpx, right: 4.rpx),
                          height: 14.rpx,
                          child: Text(
                            star,
                            style: TextStyle(
                              fontSize: 10.rpx,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffEEC88A),
                          borderRadius: BorderRadius.circular(2.rpx),
                        ),
                        margin: EdgeInsets.only(left: 8.rpx),
                        width: 28.rpx,
                        height: 14.rpx,
                        alignment: Alignment.center,
                        child: Text(
                          "Lv ${model.cavLevel}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.rpx,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "粉丝：${model.fansNum ?? 0}",
                        style: TextStyle(
                            color: const Color(0xff999999), fontSize: 10.rpx),
                      ),
                      SizedBox(
                        width: 24.rpx,
                      ),
                      Text(
                        "${model.creationNum ?? 0}创作",
                        style: TextStyle(
                            color: const Color(0xff999999), fontSize: 10.rpx),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.rpx),
            GestureDetector(
              onTap: () {
                controller.fetchAttention(index);
              },
              child: GetBuilder<MineAttentionController>(builder: (controller) {
                return Container(
                  decoration: BoxDecoration(
                    color: bgColorForStatus(model.mutualFollow),
                    borderRadius: BorderRadius.circular(4.rpx),
                  ),
                  width: 70.rpx,
                  height: 24.rpx,
                  alignment: Alignment.center,
                  child: Text(
                    model.mutualFollow.title,
                    style: TextStyle(
                        color: textColorForStatus(model.mutualFollow),
                        fontSize: 12.rpx),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Color textColorForStatus(UserAttentionStatus status) {
    switch (status) {
      case UserAttentionStatus.notFollowing:
        return Colors.white;
      default:
        return AppColor.gray5;
    }
  }

  Color bgColorForStatus(UserAttentionStatus status) {
    switch (status) {
      case UserAttentionStatus.notFollowing:
        return AppColor.primary;
      default:
        return AppColor.gray14;
    }
  }
}
