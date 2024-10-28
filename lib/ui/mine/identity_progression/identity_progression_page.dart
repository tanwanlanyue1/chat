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
        return wrapGradientBackground(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Positioned(
                  top: Get.mediaQuery.padding.top + 42.rpx,
                  right: 16.rpx,
                  child: AppImage.asset(
                    state.audit == 0 ?
                    "assets/images/mine/under_review.png":
                    state.audit == 1 ?
                    "assets/images/mine/successful_audit.png":
                    "assets/images/mine/audit_failure.png",
                    width: 133.rpx,height: 144.rpx,),
                ),
                Column(
                  children: [
                    AppBar(
                      systemOverlayStyle: SystemUI.lightStyle,
                      leading: const AppBackButton(brightness:Brightness.light),
                      backgroundColor: Colors.transparent,
                    ),
                    Expanded(
                      child: copyWriting(),
                    ),
                  ],
                ),
              ],
            ),
          )
        );
      },
    );
  }

  //审核文案
  Widget copyWriting(){
    return Container(
      padding: EdgeInsets.only(top: 20.rpx),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 24.rpx,bottom: 12.rpx),
            child: Text(state.audit == 0 ?
            S.current.underReview:
            state.audit == 1 ?
            S.current.successfulAudit:S.current.auditFailure,style: AppTextStyle.fs24m.copyWith(color: Colors.white),),
          ),
          Visibility(
            visible: state.audit == 1,
            replacement: Visibility(
              visible: state.audit == 0,
              replacement: Padding(
                padding: EdgeInsets.only(left: 24.rpx,bottom: 36.rpx),
                child: Text(S.current.auditTurnDown,style: AppTextStyle.fs16.copyWith(color: Colors.white.withOpacity(0.9)),),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 24.rpx,bottom: 36.rpx),
                child: Text(S.current.dataSubmitted,style: AppTextStyle.fs16.copyWith(color: Colors.white.withOpacity(0.9)),),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 24.rpx,bottom: 36.rpx),
              child: Text("${S.current.congratulations}${state.current == 0 ? S.current.customer : state.current == 1 ? S.current.goodGirl:S.current.brokerP}",style: AppTextStyle.fs16.copyWith(color: Colors.white.withOpacity(0.9)),),
            ),
          ),
          state.audit == 0 ?
          jiaAudit():
          state.audit == 1 ?
          auditSucceed():
          auditLose(),
          SizedBox(height: 40.rpx,),
          Visibility(
            visible: state.current != 2 && state.audit != 0,
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

  //审核中
  Widget jiaAudit(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.rpx),
      padding: EdgeInsets.symmetric(vertical: 36.rpx,horizontal: 16.rpx),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.rpx)
      ),
      child: Column(
        children: [
          Text(S.current.underReview,style: AppTextStyle.fs20.copyWith(color: AppColor.black20),),
          SizedBox(height: 12.rpx,),
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
            margin: EdgeInsets.only(top: 36.rpx),
            padding: EdgeInsets.symmetric(horizontal: 16.rpx),
            child: Row(
              children: [
                AppImage.asset('assets/images/mine/prosperity.png',width: 16.rpx,height: 16.rpx,),
                SizedBox(width: 8.rpx),
                Text(S.current.submitted,style: AppTextStyle.fs14.copyWith(color: AppColor.black666)),
                const Spacer(),
                Text(CommonUtils.timestamp(state.advanced.createTime,unit: "yyyy.MM.dd hh:mm"),style: AppTextStyle.fs14.copyWith(color: AppColor.gray9),),
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
      margin: EdgeInsets.symmetric(horizontal: 16.rpx),
      padding: EdgeInsets.symmetric(vertical: 36.rpx,horizontal: 16.rpx),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.rpx)
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...List.generate(state.interests.length, (index) {
            var item = state.interests[index];
            return Container(
              padding: EdgeInsets.only(bottom: index == state.interests.length-1 ? 0: 32.rpx),
              child: Row(
                children: [
                  AppImage.asset(item['image'],width: 28.rpx,height: 28.rpx,),
                  SizedBox(width: 12.rpx,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['title'],style: AppTextStyle.fs16.copyWith(color: AppColor.gray5),),
                      Text(item['remake'],style: AppTextStyle.fs14.copyWith(color: AppColor.gray9),),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  //审核失败
  Widget auditLose(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.rpx),
      padding: EdgeInsets.symmetric(vertical: 36.rpx,horizontal: 16.rpx),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.rpx)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(S.current.auditTurnDown,style: AppTextStyle.fs20.copyWith(color: AppColor.textRed),)
            ],
          ),
          SizedBox(height: 12.rpx,),
          RichText(
            text: TextSpan(
              text: '${state.advanced.remark ?? ''}\n',
              style: AppTextStyle.fs14.copyWith(color: AppColor.black666,height: 1.4),
              children: <TextSpan>[
                TextSpan(
                  text: CommonUtils.timestamp(state.advanced.createTime,unit: "yyyy年MM月dd日 hh:mm"),
                  style: AppTextStyle.fs12.copyWith(color: AppColor.gray9,height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  ///渐变背景
  Widget wrapGradientBackground({required Widget child}) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          color: AppColor.scaffoldBackground,
          alignment: Alignment.topCenter,
          child: Container(
            height: 260.rpx,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AppAssetImage("assets/images/mine/audit_back.png")
              )
            ),
          ),
        ),
        child,
      ],
    );
  }
}
