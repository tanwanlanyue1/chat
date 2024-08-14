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
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.rpx),
                            child: PlazaCard(
                              item: item,
                              attention: controller.tabController.index == 1,
                              more: () {
                                controller.selectMore(item.uid,item.postId!);
                              },
                              isLike: (like){
                                controller.getCommentLike(like, index);
                              },
                              callBack: (val){
                                controller.setComment(val ?? '',index);
                              },
                            ),
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
      padding: EdgeInsets.only(top: 8.rpx),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      alignment: Alignment.centerLeft,
      height: 40.rpx,
      child: TabBar(
        controller: controller.tabController,
        labelColor: AppColor.primary,
        labelStyle: AppTextStyle.fs14b.copyWith(color: AppColor.primary),
        unselectedLabelColor: AppColor.gray9,
        unselectedLabelStyle: AppTextStyle.fs14m.copyWith(color: AppColor.black92),
        indicatorColor: AppColor.primary,
        indicatorWeight: 2.rpx,
        labelPadding: EdgeInsets.only(bottom: 12.rpx),
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
        visible: controller.tabController.index == 2,
        replacement: Container(),
        child: GestureDetector(
          onTap: (){
            Get.toNamed(AppRoutes.releaseDynamicPage);
          },
          child: Container(
            width: 80.rpx,
            height: 40.rpx,
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
      );
    },);
  }
}
