
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

import '../../../../../common/network/api/model/talk_model.dart';

///提示弹窗
Future<T?> FulfillShowDiglog<T>({
  String? title = '提示',
  RecordDetailsModel? item,
  Function? callBack,
}){
  return Get.dialog(
    Center(
      child: Container(
        height: 300.rpx,
        decoration: BoxDecoration(
          color: Colors.white,
            borderRadius: BorderRadius.circular(16.rpx)
        ),
        margin: EdgeInsets.symmetric(horizontal: 16.rpx),
        padding: EdgeInsets.symmetric(horizontal: 20.rpx),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      "$title",
                      style: AppTextStyle.fs18b.copyWith(color: AppColor.red1),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Get.back();
                  },
                  child: SizedBox(
                    width: 50.rpx,
                    height: 50.rpx,
                    child: const Icon(Icons.close,color: Color(0xff684326),),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 16.rpx),
              child: Text(
                "感恩不断努力的自己，谢谢自己坚持行愿。",
                style: AppTextStyle.fs16b.copyWith(color: AppColor.gray5),
              ),
            ),
            Text("完愿后的天灯将不再显示在场景中，您可在“我的”里面找到记录。",style: AppTextStyle.fs16m.copyWith(color: AppColor.gray5)),
            Container(
              margin: EdgeInsets.only(top: 20.rpx),
              child: Text("本次完愿后：功德+${item?.gift?.mavNum ?? 1}  修行值+${item?.gift?.cavNum ?? 1}。",style: AppTextStyle.fs12m.copyWith(color: AppColor.gray5)),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.rpx),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        Get.back();
                      },
                      child: Container(
                        height: 40.rpx,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1.5.rpx,color: AppColor.red1),
                            borderRadius: BorderRadius.circular(20.rpx)
                        ),
                        alignment: Alignment.center,
                        child: Text("取消",style: AppTextStyle.fs18b.copyWith(color: AppColor.red1),),
                      ),
                    ),
                  ),
                  SizedBox(width: 24.rpx,),//state.selectAging
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        callBack?.call();
                      },
                      child: Container(
                        height: 40.rpx,
                        decoration: BoxDecoration(
                            color: AppColor.red1,
                            borderRadius: BorderRadius.circular(20.rpx)
                        ),
                        alignment: Alignment.center,
                        child: Text("确定",style: AppTextStyle.fs18b.copyWith(color: Colors.white),),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
  );
}