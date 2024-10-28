import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/app_image.dart';

//发布帖子-成功
class PublishSuccess extends StatelessWidget {
  const PublishSuccess({super.key});

  static Future<bool?> show() {
    return Get.dialog(
      const PublishSuccess(),
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
            height: 450.rpx,
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColor.gradientBegin,
                    AppColor.gradientEnd,
                  ],
                ),
              borderRadius: BorderRadius.all(Radius.circular(8.rpx)),
            ),
            padding: EdgeInsets.all(16.rpx),
            child: Column(
              children: [
                GestureDetector(
                  onTap: (){
                    Get.back();
                  },
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: AppImage.asset('assets/images/common/close.png',width: 24.rpx,height: 24.rpx,),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AppAssetImage('assets/images/discover/issue.png')
                      )
                  ),
                  width: 270.rpx,
                  height: 270.rpx,
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.only(bottom: 16.rpx,left: 24.rpx),
                  child: Text("${S.current.releaseSuccess}！",style: AppTextStyle.fs24.copyWith(color: Colors.white,fontWeight: FontWeight.w700),),
                ),
                Text(S.current.ifUserRepliesToYou,style: AppTextStyle.fs14.copyWith(color: Colors.white),),
                const Spacer(),
                GestureDetector(
                  onTap: (){
                    Get.back();
                    Get.back();
                  },
                  child: Container(
                    height: 50.rpx,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8.rpx)),
                    ),
                    alignment: Alignment.center,
                    child: Text(S.current.backToView,style: AppTextStyle.fs16m.copyWith(color: AppColor.gray5),),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
