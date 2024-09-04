import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/chat/utils/chat_manager.dart';
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.speedDating[i]['name'],
                            style: AppTextStyle.fs20b
                                .copyWith(color: Colors.white),
                          ),
                          Text(
                            state.speedDating[i]['subtitle'],
                            style: AppTextStyle.fs10m
                                .copyWith(color: AppColor.white5),
                                // .copyWith(color: Colors.white),
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
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.rpx).copyWith(top: 8.rpx,bottom: 12.rpx),
          child: Row(
            children: [
              Text(
                S.current.datingHall,
                style: AppTextStyle.fs16b.copyWith(color: AppColor.black20),
              ),
              const Spacer(),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: controller.onTapFiltrate,
                child: Row(
                  children: [
                    Text(
                      S.current.filtrate,
                      style:
                      AppTextStyle.fs12m.copyWith(color: AppColor.gray5),
                    ),
                    SizedBox(width: 4.rpx,),
                    AppImage.asset(
                      'assets/images/plaza/screen.png',
                      width: 16.rpx,
                      height: 16.rpx,
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
    );
  }

  //交友项
  Widget friendsItem(RecommendModel item) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => Get.toNamed(AppRoutes.userCenterPage, arguments: {'userId': item.uid}),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.rpx).copyWith(bottom: 8.rpx),
        padding: EdgeInsets.all(16.rpx).copyWith(right: 8.rpx),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.rpx),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(right: 12.rpx),
              child: AppImage.network(
                item.avatar ?? '',
                width: 80.rpx,
                height: 80.rpx,
                borderRadius: BorderRadius.circular(16.rpx),
              ),
            ),
            Expanded(child: SizedBox(
                  height: 80.rpx,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: (item.age != null || item.style != null) ? MainAxisAlignment.spaceAround : MainAxisAlignment.center,
                    children: [
                      Text(
                        item.nickname ?? '',
                        style: AppTextStyle.fs16b.copyWith(color: AppColor.black20,height: 1),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6.rpx,),
                      Visibility(
                        visible: item.age != null || item.style != null,
                        child: Row(
                          children: [
                            Text(
                              item.age != null ? "${item.age}${S.current.yearAge}":"",
                              style:
                              AppTextStyle.fs12m.copyWith(color: AppColor.black92,height: 1),
                            ),
                            Text(
                              (item.age != null && item.style != null) ? "|":"",
                              style: AppTextStyle.fs12m.copyWith(color: AppColor.black92,height: 1),
                            ),
                            Expanded(
                                child: Text(
                                  item.style?.replaceAll(',', '｜') ?? '',
                                  style:
                                  AppTextStyle.fs12m.copyWith(color: AppColor.black92,height: 1),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )),
                          ],
                        ),
                      ),
                      item.images != null
                      ? Container(
                        margin: EdgeInsets.only(top: 6.rpx),
                        child: Row(
                          children: List.generate(
                              jsonDecode(item.images).length > 3
                                  ? 3
                                  : jsonDecode(item.images).length, (index) => Container(
                            margin: EdgeInsets.only(right: 8.rpx),
                            child: AppImage.network(
                              jsonDecode(item.images)[index],
                              width: 36.rpx,
                              height: 36.rpx,
                              borderRadius: BorderRadius.circular(4.rpx),
                            ),
                          )),
                        ),
                      )
                      : Container(),
                    ],
                  ),
                )),
            GestureDetector(
              onTap: (){
                ChatManager().startChat(userId: item.uid!);
              },
              behavior: HitTestBehavior.translucent,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.rpx),
                  gradient: const LinearGradient(
                    colors: [AppColor.purple4, AppColor.purple8],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                height: 38.rpx,
                width: 84.rpx,
                child: Container(
                  margin: EdgeInsets.all(1.rpx),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40.rpx),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppImage.asset(
                        'assets/images/plaza/accost.png',
                        width: 18.rpx,
                        height: 17.rpx,
                      ),
                      SizedBox(width: 4.rpx,),
                      Text("搭讪",style: AppTextStyle.fs14m.copyWith(color: AppColor.black20),)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}