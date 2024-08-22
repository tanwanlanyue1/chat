import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/chat/message_list/message_list_page.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
      backgroundColor: AppColor.white8,
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
      // bottomNavigationBar: filtrateMap(),
    );
  }

  //附近列表
  Widget nearbyItem(RecommendModel item){
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(item.avatar ?? ''),
              fit: BoxFit.fitHeight
            ),
            borderRadius: BorderRadius.circular(8.rpx),
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
                  Expanded(
                    child: Text(item.nickname ?? '',style: AppTextStyle.fs12m.copyWith(color: Colors.white),overflow: TextOverflow.ellipsis,),
                  ),
                  if(item.gender != 0 && item.age != null)
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
                        Visibility(
                          visible: item.gender != 0,
                          child: AppImage.asset(item.gender == 1 ? "assets/images/plaza/boy.png" : "assets/images/plaza/girl.png",width: 12.rpx,height: 12.rpx,),
                        ),
                        Text("${item.age ?? ''}",style: AppTextStyle.fs10m.copyWith(color: Colors.white),),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 30.rpx,
              decoration: BoxDecoration(
                color: AppColor.gradientBegin,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8.rpx),
                  bottomRight: Radius.circular(8.rpx),
                ),
              ),
              padding: EdgeInsets.only(left: 8.rpx,right: 4.rpx),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        AppImage.asset("assets/images/plaza/location.png",width: 16.rpx,height: 16.rpx,),
                        Text(" ${item.distance ?? ''}km",style: AppTextStyle.fs12m.copyWith(color: Colors.white),),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        MessageListPage.go(userId: item.uid!);
                      },
                      child: Row(
                        children: [
                          AppImage.asset("assets/images/plaza/relation.png",width: 14.rpx,height: 14.rpx,),
                          Text("  联系Ta",style: AppTextStyle.fs12m.copyWith(color: Colors.white),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      onTap: (){
        Get.toNamed(AppRoutes.userCenterPage, arguments: {'userId': item.uid,});
      },
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
              behavior: HitTestBehavior.translucent,
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
