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
      body: Stack(
        children: [
          SmartRefresher(
            controller: controller.pagingController.refreshController,
            onRefresh: controller.pagingController.onRefresh,
            child: PagedGridView(
              pagingController: controller.pagingController,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 9.rpx,
                  mainAxisSpacing: 9.rpx,
                  mainAxisExtent: 220.rpx
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.rpx),
              builderDelegate: DefaultPagedChildBuilderDelegate<RecommendModel>(
                pagingController: controller.pagingController,
                itemBuilder: (_, item, index) {
                  return nearbyItem(item);
                },
              ),
            ),
          ),
          GroundGlass(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: filtrateMap(),
    );
  }

  //附近列表
  Widget nearbyItem(RecommendModel item){
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(item.avatar ?? ''),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter
          ),
          borderRadius: BorderRadius.circular(8.rpx),
        ),
        height: 220.rpx,
        alignment: Alignment.bottomLeft,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0),
                Colors.black.withOpacity(0.5),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8.rpx),
              bottomRight: Radius.circular(8.rpx),
            ),
          ),
          child: Container(
            height: 50.rpx,
            decoration: BoxDecoration(
              color: item.gender == 1 ? AppColor.primaryBlue.withOpacity(0.1):AppColor.textPurple.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8.rpx),
                bottomRight: Radius.circular(8.rpx),
              ),
            ),
            padding: EdgeInsets.only(left: 4.rpx,right: 4.rpx,top: 8.rpx),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.nickname ?? '',style: AppTextStyle.fs12m.copyWith(color: AppColor.black3,height: 1.0),overflow: TextOverflow.ellipsis,),
                    // Expanded(
                    //   child: GestureDetector(
                    //     onTap: (){
                    //       ChatManager().startChat(userId: item.uid!);
                    //     },
                    //     child: Row(
                    //       children: [
                    //         AppImage.asset("assets/images/plaza/relation.png",width: 14.rpx,height: 14.rpx,),
                    //         Text("  ${S.current.contactBeauty}",style: AppTextStyle.fs12m.copyWith(color: Colors.white),),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                if(item.gender != 0 || item.age != null)
                  Container(
                    decoration: BoxDecoration(
                        color: item.gender == 1 ? AppColor.primaryBlue.withOpacity(0.15):AppColor.textPurple.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12.rpx)
                    ),
                    width: 33.rpx,
                    height: 16.rpx,
                    margin: EdgeInsets.only(top: 6.rpx),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: item.gender != 0,
                          child: AppImage.asset(item.gender == 1 ? "assets/images/plaza/boy.png" : "assets/images/plaza/girl.png",width: 12.rpx,height: 12.rpx,color: item.gender == 1 ? AppColor.primaryBlue:AppColor.textPurple),
                        ),
                        Text("${item.age ?? ''}",style: AppTextStyle.fs10.copyWith(color: item.gender == 1 ? AppColor.primaryBlue:AppColor.textPurple),),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        // child: Container(
        //   height: 20.rpx,
        //   padding: EdgeInsets.symmetric(horizontal: 4.rpx),
        //   decoration: BoxDecoration(
        //     color: AppColor.gray33,
        //     borderRadius: BorderRadius.only(
        //       topRight: Radius.circular(8.rpx),
        //     ),
        //   ),
        //   child: Row(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       AppImage.asset("assets/images/plaza/location.png",width: 12.rpx,height: 12.rpx,),
        //       Text(" ${item.distance ?? ''}km",style: AppTextStyle.fs12.copyWith(color: Colors.white),),
        //     ],
        //   ),
        // ),
      ),
      onTap: (){
        Get.toNamed(AppRoutes.userCenterPage, arguments: {'userId': item.uid,});
      },
    );
  }

  //筛选
  Widget filtrateMap(){
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
                spreadRadius: 0
            ),
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
                            colors: [AppColor.gradientBegin, AppColor.gradientEnd],
                          ).createShader(Offset.zero & bounds.size);
                        },
                        blendMode: BlendMode.srcATop,
                        child: Container(
                          margin: EdgeInsets.only(right: 8.rpx),
                          child: Text(
                            S.current.map,
                            style:AppTextStyle.fs12,
                          ),
                        )
                    ),
                    AppImage.asset("assets/images/plaza/map.png",width: 24.rpx,height: 24.rpx,),
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
                            S.current.filtrate,
                            style:AppTextStyle.fs12,
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
      ),
    ));
  }
}
