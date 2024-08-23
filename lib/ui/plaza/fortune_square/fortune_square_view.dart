import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/ui/plaza/widgets/plaza_card.dart';
import 'package:guanjia/widgets/advertising_swiper.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

import '../../../common/network/api/model/talk_model.dart';
import 'fortune_square_controller.dart';

///社区
class FortuneSquareView extends StatelessWidget {
  FortuneSquareView({Key? key}) : super(key: key);

  final controller = Get.put(FortuneSquareController());
  final state = Get.find<FortuneSquareController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          discoverClassify(),
          Expanded(
            child: SmartRefresher(
              controller: controller.pagingController.refreshController,
              onRefresh: controller.pagingController.onRefresh,
              child: CustomScrollView(
                slivers: [
                  PagedSliverList(
                    pagingController: controller.pagingController,
                    builderDelegate: DefaultPagedChildBuilderDelegate<PlazaListModel>(
                        pagingController: controller.pagingController,
                        itemBuilder: (_,item,index){
                          return PlazaCard(
                            item: item,
                            plazaIndex: controller.tabController.index,
                            more: () {
                              controller.selectMore(item);
                            },
                            isLike: (like){
                              controller.getCommentLike(like, index);
                            },
                            callBack: (val){
                              controller.setComment(val ?? '',index);
                            },
                          );
                        }
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: floatingAction(),
    );
  }

  ///发现
  Widget discoverClassify(){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.rpx),
          topRight: Radius.circular(8.rpx),
        ),
      ),
      alignment: Alignment.centerLeft,
      height: 44.rpx,
      margin: EdgeInsets.only(bottom: 8.rpx),
      child: TabBar(
        controller: controller.tabController,
        labelColor: AppColor.gradientBegin,
        labelStyle: AppTextStyle.fs14b.copyWith(color: AppColor.gradientBegin),
        unselectedLabelColor: AppColor.gray9,
        unselectedLabelStyle: AppTextStyle.fs14m.copyWith(color: AppColor.black92),
        indicatorColor: AppColor.gradientBegin,
        indicatorPadding: EdgeInsets.only(right: 16.rpx,left: 4.rpx),
        indicatorWeight: 2.rpx,
        labelPadding: EdgeInsets.only(bottom: 12.rpx,right: 12.rpx),
        padding: EdgeInsets.only(top: 6.rpx),
        onTap: (val){
          controller.pagingController.onRefresh();
          controller.update(['floating']);
        },
        tabs: List.generate(
          state.communityTitle.length,
              (index) => Text(state.communityTitle[index]),
        ),
      ),
    );
  }

  ///浮动按钮
  Widget floatingAction(){
    return GetBuilder<FortuneSquareController>(
      id: 'floating',
      builder: (_) {
      return Visibility(
        visible: controller.tabController.index == 0,
        replacement: Visibility(
          visible: controller.tabController.index == 2,
          child: GestureDetector(
            onTap: (){
              Get.toNamed(AppRoutes.releaseDynamicPage);
            },
            child: Container(
              width: 80.rpx,
              height: 40.rpx,
              margin: EdgeInsets.only(bottom: 24.rpx),
              decoration: BoxDecoration(
                color: AppColor.purple6,
                borderRadius: BorderRadius.circular(50.rpx),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppImage.asset("assets/images/plaza/compile.png",width: 24.rpx,height: 24.rpx,),
                  Text("发帖",style: AppTextStyle.fs14m.copyWith(color: Colors.white),),
                ],
              ),
            ),
          ),
        ),
        child: filtrateMap(),
      );
    },);
  }

  //筛选
  Widget filtrateMap(){
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 46.rpx,
        width: 180.rpx,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.rpx),
          border: Border.all(color: Colors.grey.withOpacity(0.4), width: 1,),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.rpx),
        margin: EdgeInsets.only(left: 36.rpx),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
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
              child: InkWell(
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
      ),
    );
  }

}
