import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/common_gradient_button.dart';

//征友约会-弹窗
class DraftDialog extends StatelessWidget {
  const DraftDialog({super.key});

  //进阶弹窗
  static Future<bool?> show() {
    return Get.dialog(
      DraftDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.back();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            width: 331.rpx,
            height: 510.rpx,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8.rpx)),
            ),
            padding: EdgeInsets.all(16.rpx),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  child: AppImage.asset('assets/images/common/close.png',width: 24.rpx,height: 24.rpx,),
                ),
                Wrap(
                  spacing: -13.rpx,
                  children: List.generate(2, (index) {
                    return AppImage.asset(
                      "assets/images/mine/head_photo.png",
                      width: 60.rpx,
                      height: 60.rpx,
                    );
                  }),
                ),
                SizedBox(height: 12.rpx),
                Text("同意和Susie Jenkins约会？",style: AppTextStyle.fs16b.copyWith(color: AppColor.gray5),),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 12.rpx),
                  child: Text("注：为保障权益，约会双方均需缴纳保证金，保证金在订单结束后将会原路退回。",style: AppTextStyle.fs12m.copyWith(color: AppColor.gray9),),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColor.scaffoldBackground,
                    borderRadius: BorderRadius.all(Radius.circular(8.rpx)),
                  ),
                  padding: EdgeInsets.all(24.rpx),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Ta愿支付",style: AppTextStyle.fs14b.copyWith(color: AppColor.gray5),),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.rpx),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("服务费",style: AppTextStyle.fs14m.copyWith(color: AppColor.black6),),
                            Text("\$650",style: AppTextStyle.fs14b.copyWith(color: AppColor.gray5),),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("保证金",style: AppTextStyle.fs14m.copyWith(color: AppColor.black6),),
                          Text("\$650",style: AppTextStyle.fs14b.copyWith(color: AppColor.primary),),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 16.rpx),
                        color: AppColor.black1A,
                        height: 2.rpx,
                      ),
                      Text("你需支付",style: AppTextStyle.fs14b.copyWith(color: AppColor.gray5),),
                      SizedBox(height: 16.rpx),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("保证金",style: AppTextStyle.fs14m.copyWith(color: AppColor.black6),),
                          Text("\$650",style: AppTextStyle.fs14b.copyWith(color: AppColor.primary),),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                CommonGradientButton(
                  height: 50.rpx,
                  text: "同意约会",
                  onTap: (){
                    print("123");
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
