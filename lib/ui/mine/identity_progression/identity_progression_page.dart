import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/utils/common_utils.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/app_back_button.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/button.dart';
import 'package:guanjia/widgets/system_ui.dart';

import 'identity_progression_controller.dart';

///身份进阶页
class IdentityProgressionPage extends StatelessWidget {
  IdentityProgressionPage({Key? key}) : super(key: key);

  final controller = Get.put(IdentityProgressionController());
  final state = Get.find<IdentityProgressionController>().state;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IdentityProgressionController>(
      builder: (_){
        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Visibility(
                visible: state.audit == 2,
                child: AppImage.asset("assets/images/mine/lose_back.png",height: 346.rpx,),
              ),
              Column(
                children: [
                  AppBar(
                    title: Text(
                      state.audit == 0 ?
                      S.current.underReview:
                      state.audit == 1 ? S.current.successfulAudit :
                      S.current.auditFailure,
                      style: TextStyle(
                        color: state.audit == 2 ? Colors.white : const Color(0xff333333),
                        fontSize: 18.rpx,
                      ),
                    ),
                    elevation: 5.rpx,
                    shadowColor: AppColor.gray11,
                    systemOverlayStyle: SystemUI.lightStyle,
                    leading: AppBackButton(brightness:state.audit == 2 ? Brightness.light : Brightness.dark),
                    backgroundColor: state.audit == 2 ? Colors.transparent : Colors.white,
                  ),
                  Expanded(
                    child: state.audit == 0 ?
                    jiaAudit():
                    state.audit == 1 ?
                    auditSucceed():
                    auditLose(),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  //审核中
  Widget jiaAudit(){
    return Container(
      margin: EdgeInsets.only(top: 36.rpx),
      child: Column(
        children: [
          AppImage.asset('assets/images/mine/wait.png',width: 70.rpx,height: 70.rpx,),
          SizedBox(height: 24.rpx,),
          Text(S.current.dataSubmitted,style: AppTextStyle.fs18m.copyWith(color: AppColor.gray5),),
          RichText(
            text: TextSpan(
              text: S.current.patient,
              style: AppTextStyle.fs14m.copyWith(color: AppColor.gray9),
              children: <TextSpan>[
                TextSpan(
                  text: S.current.customerService,
                  style: AppTextStyle.fs14m.copyWith(color: AppColor.primary),
                  recognizer: TapGestureRecognizer()..onTap=(){
                    Get.toNamed(AppRoutes.mineFeedbackPage);
                  }
                ),
                TextSpan(
                  text: S.current.monitorProgress,
                  style: AppTextStyle.fs14m.copyWith(color: AppColor.gray9),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColor.scaffoldBackground,
              borderRadius: BorderRadius.circular(8.rpx),
            ),
            height: 50.rpx,
            margin: EdgeInsets.symmetric(horizontal: 16.rpx).copyWith(top: 60.rpx),
            padding: EdgeInsets.symmetric(horizontal: 16.rpx),
            child: Row(
              children: [
                AppImage.asset('assets/images/mine/prosperity.png',width: 16.rpx,height: 16.rpx,),
                SizedBox(width: 8.rpx),
                Text(S.current.submitted,style: AppTextStyle.fs14m.copyWith(color: AppColor.gray30)),
                const Spacer(),
                Text(CommonUtils.timestamp(state.advanced.createTime,unit: "yyyy.MM.dd hh:mm"),style: AppTextStyle.fs14m.copyWith(color: AppColor.gray9),),
              ],
            ),
          )
        ],
      ),
    );
  }

  //审核成功
  Widget auditSucceed(){
    return Container(
      padding: EdgeInsets.only(top: 36.rpx,bottom: 100.rpx),
      child: Column(
        children: [
          AppImage.asset('assets/images/mine/succeed.png',width: 70.rpx,height: 70.rpx,),
          Container(
            margin: EdgeInsets.only(top: 24.rpx,bottom: 74.rpx),
            child: Text("${S.current.congratulations}${state.current == 0 ? S.current.customer : state.current == 1 ? S.current.goodGirl:S.current.brokerP}",style: AppTextStyle.fs18m.copyWith(color: AppColor.gray5),),
          ),
          ...List.generate(state.interests.length, (index) {
            var item = state.interests[index];
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16.rpx).copyWith(bottom: 24.rpx),
              child: Row(
                children: [
                  AppImage.asset(item['image'],width: 28.rpx,height: 28.rpx,),
                  SizedBox(width: 12.rpx,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['title'],style: AppTextStyle.fs16m.copyWith(color: AppColor.gray5),),
                      Text(item['remake'],style: AppTextStyle.fs14m.copyWith(color: AppColor.gray9),),
                    ],
                  ),
                ],
              ),
            );
          }),
          const Spacer(),
          Visibility(
            visible: state.current != 2,
            child: Button(
              height: 50.rpx,
              onPressed: (){
                controller.updateAudit();
              },
              margin: EdgeInsets.symmetric(horizontal: 38.rpx),
              child: Text(
                state.current == 0 ?
                S.current.generalBroker:
                state.current == 1 ?
                S.current.generalUser:
                S.current.generalGood,
                style: TextStyle(color: Colors.white, fontSize: 16.rpx),
              ),
            ),
          )
        ],
      ),
    );
  }

  //审核失败
  Widget auditLose(){
    return Container(
      padding: EdgeInsets.only(top: 36.rpx,bottom: 100.rpx,left: 32.rpx,right: 32.rpx),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            child: AppImage.asset('assets/images/mine/be_defeated.png',width: 70.rpx,height: 70.rpx,),
          ),
          Container(
            margin: EdgeInsets.only(top: 150.rpx,bottom: 12.rpx),
            child: Text(S.current.reviewReject,style: AppTextStyle.fs20m.copyWith(color: AppColor.red53),),
          ),
          RichText(
            text: TextSpan(
              text: '${state.advanced.remark ?? ''}\n',
              style: AppTextStyle.fs14m.copyWith(color: AppColor.gray30,height: 1.4),
              children: <TextSpan>[
                TextSpan(
                  text: CommonUtils.timestamp(state.advanced.createTime,unit: "yyyy年MM月dd日 hh:mm"),
                  style: AppTextStyle.fs12m.copyWith(color: AppColor.gray9,height: 1.4),
                ),
              ],
            ),
          ),
          const Spacer(),
          Button(
            height: 50.rpx,
            onPressed: (){
              controller.updateAudit();
            },
            margin: EdgeInsets.symmetric(horizontal: 38.rpx),
            child: Text(
              state.current == 0 ?
              S.current.generalBroker:
              state.current == 1 ?
              S.current.generalUser:
              S.current.generalGood,
              style: TextStyle(color: Colors.white, fontSize: 16.rpx),
            ),
          )
        ],
      ),
    );
  }
}
