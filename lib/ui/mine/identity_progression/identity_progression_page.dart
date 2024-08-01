import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';

import 'identity_progression_controller.dart';

///身份进阶页
class IdentityProgressionPage extends StatelessWidget {
  IdentityProgressionPage({Key? key}) : super(key: key);

  final controller = Get.put(IdentityProgressionController());
  final state = Get.find<IdentityProgressionController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "身份进阶审核",
          style: TextStyle(
            color: const Color(0xff333333),
            fontSize: 18.rpx,
          ),
        ),
        elevation: 5.rpx,
        shadowColor: AppColor.gray11,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          jiaAudit(),
        ],
      ),
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
          Text("申请资料已提交",style: AppTextStyle.fs18m.copyWith(color: AppColor.gray5),),
          Text("请耐心等待，可询问客服关注进度",style: AppTextStyle.fs14m.copyWith(color: AppColor.gray9),textAlign: TextAlign.center,),
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
                Text("已提交",style: AppTextStyle.fs14m.copyWith(color: AppColor.gray30)),
                const Spacer(),
                Text("2024.03.24 14:32",style: AppTextStyle.fs14m.copyWith(color: AppColor.gray9),),
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
      child: Column(
        children: [
          AppImage.asset('assets/images/mine/wait.png',width: 70.rpx,height: 70.rpx,),
          SizedBox(height: 24.rpx,),
          Text("恭喜您成为佳丽",style: AppTextStyle.fs18m.copyWith(color: AppColor.gray5),),
          GestureDetector(
            onTap: null,
            child: Container(
              height: 42.rpx,
              decoration: BoxDecoration(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(8.rpx)),
              margin: EdgeInsets.symmetric(horizontal: 38.rpx, vertical: 40.rpx),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "确定",
                    style: TextStyle(color: Colors.white, fontSize: 16.rpx),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
