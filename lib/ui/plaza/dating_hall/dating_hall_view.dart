import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/chat/chat_manager.dart';
import 'package:guanjia/ui/chat/message_list/message_list_page.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/button.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../common/network/api/api.dart';
import 'dating_hall_controller.dart';

/// 推荐
class DatingHallView extends StatelessWidget {
  DatingHallView({super.key});

  final controller = Get.put(RectifyTheWorkplaceController());
  final state = Get.find<RectifyTheWorkplaceController>().state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildSpeedDating(),
        Expanded(
          child: hallItem(),
        ),
      ],
    );
  }

  ///速配
  Widget buildSpeedDating() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.rpx).copyWith(left: 15.rpx),
      margin: EdgeInsets.symmetric(vertical: 12.rpx),
      child: Row(
        children: List.generate(
            state.speedDating.length,
            (i) => Expanded(
                  child: GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image:
                                  AppAssetImage(state.speedDating[i]['image']),
                              fit: BoxFit.fitWidth),
                          borderRadius: BorderRadius.circular(8.rpx)),
                      height: 70.rpx,
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(right: 15.rpx),
                      padding: EdgeInsets.only(left: 8.rpx),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.speedDating[i]['name'],
                            style: AppTextStyle.fs22b
                                .copyWith(color: Colors.white),
                          ),
                          Text(
                            state.speedDating[i]['subtitle'],
                            style: AppTextStyle.fs10m
                                .copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Get.toNamed(
                        AppRoutes.speedDatingPage,
                        arguments: {"isVideo": state.speedDating[i]['isVideo']},
                      );
                    },
                  ),
                )),
      ),
    );
  }

  ///交友大厅列表
  Widget hallItem() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.rpx),
          topRight: Radius.circular(20.rpx),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.rpx),
            height: 45.rpx,
            child: Row(
              children: [
                Text(
                  "交友大厅",
                  style: AppTextStyle.fs16b.copyWith(color: AppColor.black20),
                ),
                const Spacer(),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: controller.onTapFiltrate,
                  child: Row(
                    children: [
                      Text(
                        "筛选",
                        style:
                            AppTextStyle.fs12m.copyWith(color: AppColor.gray5),
                      ),
                      const Icon(
                        Icons.arrow_drop_down_sharp,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: SmartRefresher(
              controller: controller.pagingController.refreshController,
              onRefresh: controller.pagingController.onRefresh,
              child: PagedListView(
                pagingController: controller.pagingController,
                builderDelegate: DefaultPagedChildBuilderDelegate<RecommendModel>(
                  pagingController: controller.pagingController,
                  itemBuilder: (_, item, index) {
                    return friendsItem(item);
                  },
                ),
              ),
          )),
        ],
      ),
    );
  }

  //交友项
  Widget friendsItem(RecommendModel item) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => Get.toNamed(AppRoutes.userCenterPage, arguments: {'userId': item.uid}),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.rpx, horizontal: 16.rpx),
        margin: EdgeInsets.only(bottom: 8.rpx),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 8.rpx),
                  child: AppImage.network(
                    item.avatar ?? '',
                    width: 50.rpx,
                    height: 50.rpx,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                    child: SizedBox(
                      height: 50.rpx,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: (item.age != null || item.style != null) ? MainAxisAlignment.spaceAround : MainAxisAlignment.center,
                        children: [
                          Text(
                            item.nickname ?? '',
                            style: AppTextStyle.fs16b.copyWith(color: AppColor.black20),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Visibility(
                            visible: item.age != null || item.style != null,
                            child: Row(
                              children: [
                                Text(
                                  item.age != null ? "${item.age}岁":"",
                                  style:
                                  AppTextStyle.fs12m.copyWith(color: AppColor.black92),
                                ),
                                Text(
                                  (item.age != null && item.style != null) ? "|":"",
                                  style:
                                  AppTextStyle.fs12m.copyWith(color: AppColor.black92),
                                ),
                                Expanded(
                                    child: Text(
                                      item.style?.replaceAll(',', '｜') ?? '',
                                      style:
                                      AppTextStyle.fs12m.copyWith(color: AppColor.black92),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
                Button.stadium(
                  onPressed: () {
                    ChatManager().startChat(userId: item.uid!);
                  },
                  width: 82.rpx,
                  height: 28.rpx,
                  backgroundColor:
                  item.gender == 1 ? AppColor.textBlue : AppColor.purple6,
                  child: Text(
                    S.current.getTouchWith,
                    style: AppTextStyle.fs12m.copyWith(color: Colors.white),
                  ),
                )
              ],
            ),
            item.images != null
                ? Container(
                  margin: EdgeInsets.only(left: 54.rpx,top: 12.rpx),
                  child: Row(
                      children: List.generate(
                          jsonDecode(item.images).length > 3
                              ? 3
                              : jsonDecode(item.images).length, (index) => Container(
                                margin: EdgeInsets.only(right: 3.rpx),
                                child: AppImage.network(
                                  jsonDecode(item.images)[index],
                                  width: 93.rpx,
                                  height: 93.rpx,
                                  borderRadius: BorderRadius.circular(8.rpx),
                                ),
                          )),
                    ),
                  )
                : Container(),
            Container(
              height: 1.rpx,
              margin: EdgeInsets.only(top: 24.rpx,left: 54.rpx),
              color: AppColor.white8,
            )
          ],
        ),
      ),
    );
  }
}