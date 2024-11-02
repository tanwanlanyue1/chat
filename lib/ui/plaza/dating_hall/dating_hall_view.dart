import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
import 'package:guanjia/widgets/common_gradient_button.dart';
import 'package:guanjia/widgets/user_style.dart';
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
                              image: AppAssetImage(state.speedDating[i]['image']),
                              fit: BoxFit.fitWidth)),
                      height: 70.rpx,
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(right: 15.rpx),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 8.rpx),
                            child: AppImage.asset(state.speedDating[i]['text'],height: 24.rpx,),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 4.rpx,top: 3.rpx),
                            padding: EdgeInsets.only(left: 4.rpx,top: 3.rpx,bottom: 3.rpx),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.16),
                                  Colors.white.withOpacity(0),
                                ]
                              ),
                              borderRadius: BorderRadius.circular(4.rpx)
                            ),
                            child: Text(
                              state.speedDating[i]['subtitle'],
                              style: AppTextStyle.fs10
                                  .copyWith(color: AppColor.white5,height: 1.0),
                            ),
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
          margin: EdgeInsets.symmetric(horizontal: 16.rpx).copyWith(top: 4.rpx,bottom: 12.rpx),
          child: Row(
            children: [
              Text(
                S.current.datingHall,
                style: AppTextStyle.fs18.copyWith(color: AppColor.black20,height: 1.0),
              ),
              const Spacer(),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: controller.onTapFiltrate,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.rpx),
                    color: Colors.white.withOpacity(0.3)
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8.rpx,vertical: 3.rpx),
                  child: Row(
                    children: [
                      Text(
                        S.current.filtrate,
                        style:
                        AppTextStyle.fs12.copyWith(color: AppColor.gray5),
                      ),
                      SizedBox(width: 2.rpx,),
                      AppImage.asset(
                        'assets/images/plaza/screen.png',
                        width: 8.rpx,
                        height: 8.rpx,
                        color: Colors.black,
                      ),
                    ],
                  ),
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
                padding: EdgeInsets.symmetric(horizontal: 16.rpx),
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
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AppAssetImage("assets/images/plaza/friend_item_back.png")
            )
        ),
        height: 90.rpx,
        padding: EdgeInsets.all(5.rpx),
        margin: EdgeInsets.only(bottom: 8.rpx),
        child: Stack(
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10.rpx),
                  child: AppImage.network(
                    item.avatar ?? '',
                    width: 80.rpx,
                    height: 80.rpx,
                    shape: BoxShape.circle,
                    // fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 8.rpx,right: 3.rpx),
                        child: Row(
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                  maxWidth: item.nameplate != null && item.nameplate!.isNotEmpty ? (Get.width-254.rpx):(Get.width-210.rpx)
                              ),
                              child: Text(
                                item.nickname ?? '',
                                style: AppTextStyle.fs14b.copyWith(color: AppColor.black20,height: 1.0,),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 4.rpx,right: 4.rpx),
                              child: AppImage.asset(UserGender.valueForIndex(item.gender ?? 0).icon,width: 12.rpx,height: 12.rpx),
                            ),
                            Visibility(
                              visible: item.nameplate != null && item.nameplate!.isNotEmpty,
                              child: AppImage.network(item.nameplate ?? '',width: 45.rpx,height: 12.rpx,fit: BoxFit.fitHeight,),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 20.rpx,
                        margin: EdgeInsets.only(right: 15.rpx),
                        child: UserStyle(styleList: item.styleList,),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 15.rpx,bottom: 10.rpx),
                        child: Text(item.signature ?? '',style: AppTextStyle.fs10.copyWith(color: AppColor.grayText,overflow: TextOverflow.ellipsis,height: 1.01),maxLines: 1,),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 3.rpx,
              right: 3.rpx,
              child: GestureDetector(
                onTap: (){
                  ChatManager().startChat(userId: item.uid!);
                },
                child: AppImage.asset('assets/images/plaza/hi_like.png',width: 52.rpx,height: 24.rpx,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}