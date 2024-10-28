import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/utils/common_utils.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/app_back_button.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../common/network/api/api.dart';
import 'mine_evaluate_controller.dart';

//我的评价
class MineEvaluatePage extends StatelessWidget {
  MineEvaluatePage({Key? key}) : super(key: key);

  final controller = Get.put(MineEvaluateController());
  final state = Get.find<MineEvaluateController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton.light(),
        systemOverlayStyle: SystemUI.lightStyle,
        title: Text(S.current.myAssessment,style: AppTextStyle.fs18m.copyWith(color: Colors.white),),
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
      body: Stack(
        children: [
          backWidget(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.rpx).copyWith(top: 8.rpx),
            child: SmartRefresher(
              controller: controller.pagingController.refreshController,
              onRefresh: controller.pagingController.onRefresh,
              child: PagedListView(
                pagingController: controller.pagingController,
                builderDelegate: DefaultPagedChildBuilderDelegate<EvaluationItemModel>(
                  pagingController: controller.pagingController,
                  itemBuilder: (_, item, index) {
                    return evaluateCard(item);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //背景
  Widget backWidget(){
    return Stack(
      children: [
        Container(
          height: 100.rpx,
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
          margin: EdgeInsets.only(top: 40.rpx),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(60.rpx),
              topRight: Radius.circular(60.rpx),
            ),
          ),
        ),
      ],
    );
  }

  Widget evaluateCard(EvaluationItemModel item){
    return Container(
      padding: EdgeInsets.all(16.rpx),
      margin: EdgeInsets.only(bottom: 24.rpx),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.rpx),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            offset: Offset(0, -1.rpx),
            blurRadius: 8,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8.rpx,
            offset: Offset(0, 8.rpx),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 22.rpx),
            child: AppImage.network(
              width: 50.rpx,
              height: 50.rpx,
              item.toImg,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8.rpx,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: AutoSizeText(
                            minFontSize: 10,
                            maxLines: 2,
                            item.toName,
                            style: AppTextStyle.fs16m.copyWith(
                              color: AppColor.gray5,
                            ),
                          ),
                        ),
                        SizedBox(width: 4.rpx,),
                        Text(CommonUtils.timestamp(item.createTime,unit: "yyyy年MM月dd日"),style: AppTextStyle.fs10.copyWith(color: AppColor.gray9),),
                      ],
                    ),
                    SizedBox(height: 8.rpx),
                    Row(
                      children: [
                        ...List.generate(5, (i) => Container(
                          margin: EdgeInsets.only(right: 12.rpx),
                          child: AppImage.asset(
                            width: 24.rpx,
                            height: 24.rpx,
                            i < item.star ?
                            'assets/images/mine/star.png':
                            'assets/images/mine/star_none.png',
                          ),
                        ))
                      ],
                    ),
                  ],
                ),
                Container(
                    margin: EdgeInsets.only(top: 8.rpx),
                    child: Text(item.content,style: AppTextStyle.fs12.copyWith(color: AppColor.black4E),)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
