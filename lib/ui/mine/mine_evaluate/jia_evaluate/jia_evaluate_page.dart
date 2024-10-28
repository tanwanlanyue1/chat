import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/paging/default_status_indicators/no_items_found_indicator.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/mine/mine_evaluate/widget/evaluate_card.dart';
import 'package:guanjia/widgets/app_back_button.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/system_ui.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../common/network/api/api.dart';
import 'jia_evaluate_controller.dart' ;

//佳丽-评价我的
class JiaEvaluatePage extends StatelessWidget {
  JiaEvaluatePage({Key? key}) : super(key: key);

  final controller = Get.put(JiaEvaluateController());
  final state = Get.find<JiaEvaluateController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton.light(),
        systemOverlayStyle: SystemUI.lightStyle,
        title: Text(S.current.appraiseMe,style: AppTextStyle.fs18m.copyWith(color: Colors.white),),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                AppColor.gradientBegin,
                AppColor.gradientEnd,
              ],
            )
          ),
        ),
      ),
      backgroundColor: AppColor.grayF7,
      body: GetBuilder<JiaEvaluateController>(
        builder: (_) {
        return Column(
          children: [
            personInfo(),
            Expanded(
              child: SmartRefresher(
                  controller: controller.pagingController.refreshController,
                  onRefresh: controller.pagingController.onRefresh,
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                          child: mineLabel()
                      ),
                      SliverToBoxAdapter(
                          child: customerEvaluation()
                      ),
                      PagedSliverList.separated(
                        pagingController: controller.pagingController,
                        builderDelegate: DefaultPagedChildBuilderDelegate<EvaluationItemModel>(
                          pagingController: controller.pagingController,
                          noItemsFoundIndicatorBuilder:(_){
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 16.rpx).copyWith(bottom: 24.rpx),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(8.rpx),
                                  bottomLeft: Radius.circular(8.rpx),
                                )
                              ),
                              child: NoItemsFoundIndicator(
                                title: S.current.noData,
                              ),
                            );
                          },
                          itemBuilder: (_, item, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.rpx),
                              child: EvaluateCard(
                                index: index,
                                item: item,
                                goodGirl: true,
                                margin: EdgeInsets.zero,
                                borderRadius: (index+1 == controller.pagingController.length) ?
                                BorderRadius.only(
                                  bottomRight: Radius.circular(8.rpx),
                                  bottomLeft: Radius.circular(8.rpx),
                                ):null,
                              ),
                            );
                          },
                        ),
                        separatorBuilder: (BuildContext context, int index) {
                          return Visibility(
                            visible: (index+1) != controller.pagingController.length,
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 16.rpx),
                              color: Colors.white,
                              child: Container(
                                height: 1.rpx,
                                color: AppColor.black91,
                                margin: EdgeInsets.symmetric(horizontal: 16.rpx),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  )
              ),)
          ],
        );
      },),
    );
  }

  //个人信息
  Widget personInfo(){
    return Stack(
      children: [
        Container(
          height: 70.rpx,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColor.gradientBegin,
                  AppColor.gradientEnd,
                ],
              )
          ),
        ),
        Container(
          height: 96.rpx,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.rpx),
          ),
          padding: EdgeInsets.all(16.rpx),
          margin: EdgeInsets.symmetric(horizontal: 16.rpx,vertical: 12.rpx),
          child: Row(
            children: [
              AppImage.network(
                width: 60.rpx,
                height: 60.rpx,
                state.loginService?.avatar ?? '',
                shape: BoxShape.circle,
              ),
              SizedBox(width: 12.rpx,),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 60.rpx,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(state.loginService?.nickname ?? '',style: AppTextStyle.fs18m.copyWith(color: AppColor.black20),maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 4.rpx),
                            child: Text(S.current.synthesize,style: AppTextStyle.fs12m.copyWith(color: AppColor.black4E),),
                          ),
                          ...List.generate(5, (i) => AppImage.asset(
                            width: 16.rpx,
                            height: 16.rpx,
                            i < (state.evaluation?.totalScore ?? 0) ?
                            'assets/images/mine/small_star.png':
                            'assets/images/mine/small_star_none.png',
                          ))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 60.rpx,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text("${state.evaluation?.totalAppointment ?? 0}",style: AppTextStyle.fs18m.copyWith(color: AppColor.gradientBegin,fontWeight: FontWeight.w500),),
                      ),
                      Text(S.current.cumulativeNumber,style: AppTextStyle.fs12m.copyWith(color: AppColor.black20,fontWeight: FontWeight.w500),),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  //我的标签
  Widget mineLabel(){
    return Obx(() => Container(
      padding: EdgeInsets.all(16.rpx),
      margin: EdgeInsets.symmetric(horizontal: 16.rpx).copyWith(bottom: 12.rpx),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.rpx),
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(bottom: 16.rpx),
            child: Text(S.current.myTag,style: AppTextStyle.fs14m.copyWith(color: AppColor.black20),),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 10.rpx,
              runSpacing: 12.rpx,
              children: List.generate(state.label.length, (i) {
                var item = state.label[i];
                return Visibility(
                  visible: item.isNotEmpty,
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColor.blue36,
                        borderRadius: BorderRadius.all(Radius.circular(2.rpx))
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10.rpx,vertical: 2.rpx),
                    child: Text("$item",style: AppTextStyle.fs12m.copyWith(color: AppColor.black4E,)),
                  ),
                );
              }),
            ),
          )
        ],
      ),
    ));
  }

  //客户评价
  Widget customerEvaluation(){
    return Container(
      height: 34.rpx,
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 16.rpx),
      padding: EdgeInsets.only(left: 16.rpx),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.rpx),
          topRight: Radius.circular(8.rpx),
        )
      ),
      child: Text(S.current.clientEvaluation,style: AppTextStyle.fs14m.copyWith(color: AppColor.black20),),
    );
  }
}
