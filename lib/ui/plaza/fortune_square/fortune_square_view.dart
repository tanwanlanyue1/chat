import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/edge_insets.dart';
import 'package:guanjia/widgets/spacing.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/ui/plaza/widgets/plaza_card.dart';
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
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          classifyTab(),
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
                            plazaIndex: state.communityIndex.value,
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

  //分类
  Widget classifyTab() {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.rpx,left: 16.rpx,top: 4.rpx),
      child: Obx(() =>
          Row(
            children: List<Widget>.generate(state.communityTitle.length, (i) =>
                GestureDetector(
                  onTap: (){
                    state.communityIndex.value = i;
                    controller.pagingController.onRefresh();
                    controller.update(['floating']);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 24.rpx,
                    padding: EdgeInsets.symmetric(horizontal: 10.rpx),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.rpx),
                      gradient: LinearGradient(
                        colors: state.communityIndex.value == i ? [
                          AppColor.gradientBegin.withOpacity(0.1),
                          AppColor.gradientBackgroundEnd.withOpacity(0.1),
                        ]:[AppColor.black9.withOpacity(0.1),AppColor.black9.withOpacity(0.1)]
                      ),
                    ),
                    child:
                    ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: state.communityIndex.value == i? [AppColor.gradientBegin, AppColor.gradientEnd]:[AppColor.black6,AppColor.black6],
                        ).createShader(bounds);
                      },
                      blendMode: BlendMode.srcATop,
                      child: Text(
                        '${state.communityTitle[i]}',
                        style: AppTextStyle.fs14.copyWith(height: 1.0),
                      ),
                    ),
                  ),
                ),).separated(Spacing.w8).toList(growable: false),
          )),
    );
  }

  ///浮动按钮
  Widget floatingAction(){
    return GetBuilder<FortuneSquareController>(
      id: 'floating',
      builder: (_) {
      return Visibility(
        visible: state.communityIndex.value == 0,
        replacement: Visibility(
          visible: state.communityIndex.value == 2,
          child: GestureDetector(
            onTap: (){
              Get.toNamed(AppRoutes.releaseDynamicPage);
            },
            child: Container(
              width: 50.rpx,
              height: 50.rpx,
              margin: EdgeInsets.only(bottom: 24.rpx),
              child: AppImage.asset("assets/images/plaza/compile.png",width: 24.rpx,height: 24.rpx,),
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
          boxShadow: [
            BoxShadow(
                color: AppColor.gray11,
                offset: const Offset(0, 2),
                blurRadius: 6.rpx,
                spreadRadius: 0
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.rpx),
        margin: EdgeInsets.only(left: 36.rpx),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
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
    );
  }

}
