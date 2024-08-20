import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/mine/mine_evaluate/widget/evaluate_card.dart';
import 'package:guanjia/widgets/app_back_button.dart';
import 'package:guanjia/widgets/app_image.dart';
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
      backgroundColor: AppColor.white8,
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
                      PagedSliverList(
                        pagingController: controller.pagingController,
                        builderDelegate: DefaultPagedChildBuilderDelegate<EvaluationItemModel>(
                          pagingController: controller.pagingController,
                          itemBuilder: (_, item, index) {
                            return EvaluateCard(
                              index: index,
                              item: item,
                              goodGirl: true,
                              margin: EdgeInsets.only(bottom: 1.rpx),
                            );
                          },
                        ),
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
          height: 30.rpx,
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
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.rpx),
              topRight: Radius.circular(8.rpx),
            ),
          ),
          padding: EdgeInsets.all(16.rpx),
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
                      Text("${state.loginService?.nickname}"*6 ?? '',style: AppTextStyle.fs18b.copyWith(color: AppColor.gray5),maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 4.rpx),
                            child: Text(S.current.synthesize,style: AppTextStyle.fs14m.copyWith(color: AppColor.gray9),),
                          ),
                          ...List.generate(5, (i) => AppImage.asset(
                            width: 16.rpx,
                            height: 16.rpx,
                            i < (state.evaluation?.totalScore ?? 0) ?
                            'assets/images/mine/star.png':
                            'assets/images/mine/star_none.png',
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
                      Text("${state.evaluation?.totalAppointment ?? 0}",style: AppTextStyle.fs18m.copyWith(color: AppColor.primary,fontWeight: FontWeight.w500),),
                      Text(S.current.cumulativeNumber,style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5,fontWeight: FontWeight.w500),),
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
      color: Colors.white,
      padding: EdgeInsets.all(16.rpx),
      margin: EdgeInsets.symmetric(vertical: 8.rpx),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(bottom: 16.rpx),
            child: Text(S.current.myTag,style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),),
          ),
          Wrap(
            spacing: 12.rpx,
            runSpacing: 12.rpx,
            alignment: WrapAlignment.start,
            children: List.generate(state.label.length, (i) {
              var item = state.label[i];
              return Visibility(
                visible: item.isNotEmpty,
                child: Container(
                  decoration: BoxDecoration(
                      color: AppColor.blue36,
                      borderRadius: BorderRadius.all(Radius.circular(8.rpx))
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24.rpx,vertical: 12.rpx),
                  child: Text("$item",style: AppTextStyle.fs14m.copyWith(color: AppColor.primary)),
                ),
              );
            }),
          )
        ],
      ),
    ));
  }

  //客户评价
  Widget customerEvaluation(){
    return Container(
      height: 46.rpx,
      color: Colors.white,
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(bottom: 1.rpx),
      padding: EdgeInsets.only(left: 16.rpx),
      child: Text(S.current.clientEvaluation,style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),),
    );
  }
}
