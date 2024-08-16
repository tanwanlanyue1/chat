import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'nearby_hall_controller.dart';

//交友大厅-附近
class NearbyHallView extends StatelessWidget {
  NearbyHallView({Key? key}) : super(key: key);

  final controller = Get.put(NearbyHallController());
  final state = Get.find<NearbyHallController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SmartRefresher(
        controller: controller.pagingController.refreshController,
        onRefresh: controller.pagingController.onRefresh,
        child: PagedGridView(
          pagingController: controller.pagingController,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.rpx,
              mainAxisSpacing: 8.rpx,
              mainAxisExtent: 220.rpx
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.rpx,vertical: 8.rpx),
          builderDelegate: DefaultPagedChildBuilderDelegate(
            pagingController: controller.pagingController,
            itemBuilder: (_, item, index) {
              return nearbyItem();
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: filtrateMap(),
      // bottomNavigationBar: filtrateMap(),
    );
  }

  //附近列表
  Widget nearbyItem(){
    return GestureDetector(
      child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AppAssetImage("assets/images/plaza/nearby.png")
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              color: AppColor.gray33,
              height: 30.rpx,
              padding: EdgeInsets.symmetric(horizontal: 8.rpx),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("August Castro",style: AppTextStyle.fs12m.copyWith(color: Colors.white),),
                  Container(
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColor.gradientBackgroundBegin,
                            AppColor.gradientBackgroundEnd,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(12.rpx)
                    ),
                    width: 33.rpx,
                    height: 16.rpx,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppImage.asset("assets/images/plaza/boy.png",width: 12.rpx,height: 12.rpx,),
                        Text("23",style: AppTextStyle.fs10m.copyWith(color: Colors.white),),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 30.rpx,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8.rpx),
                  bottomRight: Radius.circular(8.rpx),
                ),
              ),
              padding: EdgeInsets.only(left: 8.rpx,right: 4.rpx),
              child: Row(
                children: [
                  AppImage.asset("assets/images/plaza/location.png",width: 16.rpx,height: 16.rpx,),
                  Text(" 1.1km",style: AppTextStyle.fs12m.copyWith(color: Colors.white),),
                  const Spacer(),
                  AppImage.asset("assets/images/plaza/relation.png",width: 14.rpx,height: 14.rpx,),
                  Text("  联系Ta",style: AppTextStyle.fs12m.copyWith(color: Colors.white),),
                ],
              ),
            )
          ],
        ),
      ),
      onTap: (){},
    );
  }

  //筛选
  Widget filtrateMap(){
    return Container(
      height: 46.rpx,
      width: 180.rpx,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.rpx)
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.rpx),
      margin: EdgeInsets.only(bottom: 24.rpx),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [AppColor.gradientBegin, AppColor.gradientEnd],
                        ).createShader(Offset.zero & bounds.size);
                      },
                      blendMode: BlendMode.srcATop,
                      child: Container(
                        margin: EdgeInsets.only(right: 8.rpx),
                        child: Text(
                          "地图",
                          style:AppTextStyle.fs12m,
                        ),
                      )
                  ),
                  AppImage.asset("assets/images/plaza/map.png",width: 24.rpx,height: 24.rpx,)
                ],
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: controller.onTapFiltrate,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [AppColor.gradientBegin, AppColor.gradientEnd],
                        ).createShader(Offset.zero & bounds.size);
                      },
                      blendMode: BlendMode.srcATop,
                      child: Container(
                        margin: EdgeInsets.only(right: 8.rpx),
                        child: Text(
                          "筛选",
                          style:AppTextStyle.fs12m,
                        ),
                      )
                  ),
                  AppImage.asset("assets/images/plaza/filtrate.png",width: 24.rpx,height: 24.rpx,),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
