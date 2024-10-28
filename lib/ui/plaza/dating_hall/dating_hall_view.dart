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
import 'package:guanjia/widgets/common_gradient_button.dart';
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
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Text(
                                  state.speedDating[i]['name'],
                                  style: TextStyle(
                                      fontSize: 20.rpx,
                                      fontWeight: FontWeight.w900,
                                      fontStyle: FontStyle.italic,
                                      letterSpacing: 3.rpx,
                                      foreground: Paint()
                                        ..style = PaintingStyle.stroke
                                        ..strokeWidth = 5.rpx
                                        ..shader = LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: <Color>[
                                            Color(state.speedDating[i]['color'][0]),
                                            Color(state.speedDating[i]['color'][1]),
                                          ],
                                        ).createShader(const Rect.fromLTWH(0, 10, 80, 50))
                                  ),
                                ),
                                Text(
                                  state.speedDating[i]['name'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.rpx,
                                    fontStyle: FontStyle.italic,
                                    letterSpacing: 3.rpx,
                                    fontWeight: FontWeight.w900,),
                                ),
                              ],
                            ),
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
                              // .copyWith(color: Colors.white),
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
          margin: EdgeInsets.symmetric(horizontal: 16.rpx).copyWith(top: 8.rpx,bottom: 12.rpx),
          child: Row(
            children: [
              Text(
                S.current.datingHall,
                style: AppTextStyle.fs16m.copyWith(color: AppColor.black20),
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
                      AppTextStyle.fs12.copyWith(color: AppColor.gray5),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.rpx),
          child: AppImage.asset(
            "assets/images/plaza/friend_item.png",
            width: 270.rpx,
            height: 11.rpx,
            // fit: BoxFit.cover,
          ),
        ),
        Stack(
          children: [
            Container(
              margin: EdgeInsets.only(left: 13.rpx,right: 21.rpx,bottom: 8.rpx),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AppAssetImage((item.images != null && jsonDecode(item.images).length != 0) ?
                      'assets/images/plaza/friend_item_back.png':
                      'assets/images/plaza/friend_item_bac_no.png'
                      ),
                     fit: BoxFit.fill
                  )
              ),
              height: (item.images != null && jsonDecode(item.images).length != 0) ? 162.rpx : 70.rpx,
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => Get.toNamed(AppRoutes.userCenterPage, arguments: {'userId': item.uid}),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.rpx),
                padding: EdgeInsets.all(12.rpx).copyWith(right: 16.rpx),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16.rpx),
                    bottomLeft: Radius.circular(16.rpx),
                    bottomRight: Radius.circular(16.rpx),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 8.rpx),
                          child: AppImage.network(
                            item.avatar ?? '',
                            width: 40.rpx,
                            height: 40.rpx,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Expanded(
                            child: SizedBox(
                              height: 40.rpx,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(
                                            maxWidth: item.gender != 0 ? (Get.width-244.rpx):(Get.width-228.rpx)
                                        ),
                                        padding: EdgeInsets.only(right: item.gender == 1 ? 2.rpx : 0),
                                        child: Text(
                                          item.nickname ?? '',
                                          style: AppTextStyle.fs16m.copyWith(color: AppColor.black20,height: 1,),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Visibility(
                                        visible: (item.gender != null || item.gender != 0) && item.age != null,
                                        child: Container(
                                          height: 16.rpx,
                                          padding: EdgeInsets.symmetric(horizontal: 4.rpx),
                                          decoration: BoxDecoration(
                                              color: item.gender == 1 ? AppColor.primaryBlue.withOpacity(0.15):AppColor.textPurple.withOpacity(0.15),
                                              borderRadius: BorderRadius.circular(12.rpx)
                                          ),
                                          margin: EdgeInsets.only(left: 6.rpx),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Visibility(
                                                visible: item.gender != 0,
                                                child: Visibility(
                                                  visible: item.gender == 2,
                                                  replacement: AppImage.asset("assets/images/plaza/boy.png",width: 12.rpx,height: 12.rpx,color: AppColor.primaryBlue),
                                                  child: AppImage.asset("assets/images/plaza/girl.png",width: 12.rpx,height: 12.rpx,color: AppColor.textPurple),
                                                ),
                                              ),
                                              Text(
                                                "${item.age ?? ''}",
                                                style: AppTextStyle.fs10.copyWith(color: item.gender == 1 ? AppColor.primaryBlue:AppColor.textPurple,height: 1.2),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 6.rpx,),
                                  item.style != null ?
                                  Text(
                                    item.style?.replaceAll(',', '｜') ?? '',
                                    style:
                                    AppTextStyle.fs12m.copyWith(color: AppColor.black92,height: 1),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ):
                                  Container(),
                                ],
                              ),
                            )),
                        SizedBox(
                          height: 26.rpx,
                          width: 67.rpx,
                          child: CommonGradientButton(
                            text: S.current.getTouchWith,
                            textStyle: AppTextStyle.fs12.copyWith(color: Colors.white),
                            borderRadius: BorderRadius.circular(16.rpx),
                            onTap: (){
                              ChatManager().startChat(userId: item.uid!);
                            },
                          ),
                        ),
                      ],
                    ),
                    item.images != null && jsonDecode(item.images).length != 0
                        ? Container(
                            margin: EdgeInsets.only(top: 12.rpx,left: 48.rpx),
                            child: Row(
                              children: List.generate(
                                  jsonDecode(item.images).length > 3
                                      ? 3
                                      : jsonDecode(item.images).length, (index) => Container(
                                margin: EdgeInsets.only(right: index != 2 ? 16.rpx:0),
                                child: AppImage.network(
                                  jsonDecode(item.images)[index],
                                  width: 78.rpx,
                                  height: 78.rpx,
                                  borderRadius: BorderRadius.circular(8.rpx),
                                ),
                              )),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}