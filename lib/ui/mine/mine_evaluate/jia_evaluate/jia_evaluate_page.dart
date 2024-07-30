import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/mine/mine_evaluate/widget/evaluate_card.dart';
import 'package:guanjia/widgets/app_back_button.dart';
import 'package:guanjia/widgets/app_image.dart';

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
        title: Text("评价我的",style: AppTextStyle.fs18m.copyWith(color: Colors.white),),
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
      body: Column(
        children: [
          personInfo(),
          Expanded(
            child: ListView(
              children: [
                mineLabel(),
                customerEvaluation(),
              ],
            ),
          ),
        ],
      ),
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
              AppImage.asset(
                width: 60.rpx,
                height: 60.rpx,
                'assets/images/mine/head_photo.png',
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
                      Text("Landon",style: AppTextStyle.fs16m.copyWith(color: AppColor.gray5),),
                      Row(
                        children: [
                          Text("综合评分",style: AppTextStyle.fs14m.copyWith(color: AppColor.gray9),),
                          ...List.generate(5, (i) => AppImage.asset(
                            width: 16.rpx,
                            height: 16.rpx,
                            i == 4 ?
                            'assets/images/mine/star_none.png':
                            'assets/images/mine/star.png',
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
                      Text("88",style: AppTextStyle.fs18m.copyWith(color: AppColor.primary,fontWeight: FontWeight.w500),),
                      Text("累计约会次数",style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5,fontWeight: FontWeight.w500),),
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
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.rpx),
      margin: EdgeInsets.symmetric(vertical: 8.rpx),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(bottom: 16.rpx),
            child: Text("我的标签",style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),),
          ),
          Wrap(
            spacing: 12.rpx,
            runSpacing: 12.rpx,
            children: List.generate(state.label.length, (i) {
              var item = state.label[i];
              return Container(
                decoration: BoxDecoration(
                  color: AppColor.blue36,
                    borderRadius: BorderRadius.all(Radius.circular(8.rpx))
                ),
                padding: EdgeInsets.symmetric(horizontal: 24.rpx,vertical: 12.rpx),
                child: Text("$item",style: AppTextStyle.fs14m.copyWith(color: AppColor.primary)),
              );
            }),
          )
        ],
      ),
    );
  }

  //客户评价
  Widget customerEvaluation(){
    return Column(
      children: [
        Container(
          height: 46.rpx,
          color: Colors.white,
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(bottom: 1.rpx),
          padding: EdgeInsets.only(left: 16.rpx),
          child: Text("客户评价",style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),),
        ),
        ...List.generate(4, (index) => EvaluateCard(
          index: index,
          margin: EdgeInsets.only(bottom: 1.rpx),
        ))
      ],
    );
  }
}
