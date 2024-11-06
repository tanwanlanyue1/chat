import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/chat/utils/chat_manager.dart';
import 'package:guanjia/ui/map/map_page.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/ground_glass.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/generated/l10n.dart';

import '../../../common/network/api/api.dart';
import 'nearby_hall_controller.dart';

//交友大厅-附近
class NearbyHallView extends StatelessWidget {
  NearbyHallView({Key? key}) : super(key: key);

  final controller = Get.put(NearbyHallController());
  final state = Get.find<NearbyHallController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SmartRefresher(
        controller: controller.pagingController.refreshController,
        onRefresh: controller.pagingController.onRefresh,
        child: PagedGridView(
          pagingController: controller.pagingController,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 9.rpx,
              mainAxisSpacing: 9.rpx,
              mainAxisExtent: 220.rpx),
          padding: EdgeInsets.symmetric(horizontal: 16.rpx),
          builderDelegate: DefaultPagedChildBuilderDelegate<RecommendModel>(
            pagingController: controller.pagingController,
            itemBuilder: (_, item, index) {
              return nearbyItem(item);
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: filtrateMap(),
    );
  }

  //附近列表
  Widget nearbyItem(RecommendModel item) {
    return GestureDetector(
      child: Stack(
        children: [
          AppImage.network(
            item.avatar ?? '',
            height: 220.rpx,
            borderRadius: BorderRadius.circular(8.rpx),
            fit: BoxFit.cover,
            align: Alignment.topCenter,
          ),
          SizedBox(
            height: 220.rpx,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: item.onlineStatus == 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8.rpx),
                    ),
                    margin: EdgeInsets.only(left: 8.rpx),
                    padding: EdgeInsets.symmetric(horizontal: 4.rpx),
                    height: 14.rpx,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 4.rpx,
                          height: 4.rpx,
                          margin: EdgeInsets.only(right: 2.rpx),
                          decoration: const BoxDecoration(
                              color: AppColor.green1D, shape: BoxShape.circle),
                        ),
                        Text(
                          "在线",
                          style: AppTextStyle.fs10
                              .copyWith(height: 1.0, color: AppColor.green1D),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 48.rpx,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.black.withOpacity(0),
                      Colors.black.withOpacity(0.5),
                    ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8.rpx),
                      bottomRight: Radius.circular(8.rpx),
                    ),
                  ),
                  padding:
                      EdgeInsets.only(left: 8.rpx, top: 8.rpx, bottom: 10.rpx),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.nickname ?? '',
                              style: AppTextStyle.fs14m
                                  .copyWith(color: Colors.white, height: 1.0),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Row(
                              children: [
                                if (item.age != null)
                                  Text('${item.age ?? 0}${S.current.yearAge}',
                                      style: AppTextStyle.fs10.copyWith(
                                          color: Colors.white, height: 1.0)),
                                SizedBox(
                                  width: 4.rpx,
                                ),
                                if (item.distance != null &&
                                    double.parse(item.distance!) > 0)
                                  Expanded(
                                      child: Text(
                                    '${item.distance ?? ''}Km',
                                    style: AppTextStyle.fs10.copyWith(
                                        color: Colors.white, height: 1.0),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  )),
                              ],
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          ChatManager().startChat(userId: item.uid!);
                        },
                        child: Container(
                          width: 24.rpx,
                          height: 24.rpx,
                          margin: EdgeInsets.symmetric(horizontal: 8.rpx),
                          child:
                              AppImage.asset("assets/images/plaza/hi_icon.png"),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      onTap: () {
        Get.toNamed(AppRoutes.userCenterPage, arguments: {
          'userId': item.uid,
        });
      },
    );
  }

  //筛选
  Widget filtrateMap() {
    return Obx(() => Visibility(
          visible: SS.login.isVip,
          child: Container(
            height: 46.rpx,
            width: 180.rpx,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.rpx),
              border: Border.all(
                color: AppColor.gray39,
                width: 1.rpx,
              ),
              boxShadow: [
                BoxShadow(
                    color: AppColor.gray26,
                    offset: const Offset(0, 4),
                    blurRadius: 4.rpx,
                    spreadRadius: 0),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 20.rpx),
            margin: EdgeInsets.only(bottom: 24.rpx),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: controller.setLocation,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  AppColor.gradientBegin,
                                  AppColor.gradientEnd
                                ],
                              ).createShader(Offset.zero & bounds.size);
                            },
                            blendMode: BlendMode.srcATop,
                            child: Container(
                              margin: EdgeInsets.only(right: 8.rpx),
                              child: Text(
                                S.current.map,
                                style: AppTextStyle.fs12,
                              ),
                            )),
                        AppImage.asset(
                          "assets/images/plaza/map.png",
                          width: 24.rpx,
                          height: 24.rpx,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 1.rpx,
                  height: 30.rpx,
                  color: AppColor.white8,
                ),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: controller.onTapFiltrate,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  AppColor.gradientBegin,
                                  AppColor.gradientEnd
                                ],
                              ).createShader(Offset.zero & bounds.size);
                            },
                            blendMode: BlendMode.srcATop,
                            child: Container(
                              margin: EdgeInsets.only(right: 8.rpx),
                              child: Text(
                                S.current.filtrate,
                                style: AppTextStyle.fs12,
                              ),
                            )),
                        AppImage.asset(
                          "assets/images/plaza/filtrate.png",
                          width: 24.rpx,
                          height: 24.rpx,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
