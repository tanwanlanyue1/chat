import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/common_gradient_button.dart';
import 'package:guanjia/widgets/upload_image.dart';

import '../user_center/user_center_controller.dart';

//上传封面图-弹窗
class UploadCoverDialog extends StatelessWidget {

  static Future<bool?> show() {
    return Get.dialog(
      UploadCoverDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserCenterController>(
      id: 'upload',
      builder: (controller){
        return GestureDetector(
          onTap: (){
            Get.back();
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: GestureDetector(
              onTap: (){},
              child: Center(
                child: Container(
                  width: 331.rpx,
                  height: 400.rpx,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8.rpx)),
                  ),
                  padding: EdgeInsets.all(16.rpx),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(S.current.uploadCoverImage,style: AppTextStyle.fs16m.copyWith(color: AppColor.black20),),
                          Text(S.current.upTo6photos,style: AppTextStyle.fs12.copyWith(color: AppColor.textRed),),
                          const Spacer(),
                          GestureDetector(
                            onTap: (){
                              Get.back();
                            },
                            child: AppImage.asset('assets/images/common/close.png',width: 24.rpx,height: 24.rpx,),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 7.rpx),
                        width: 300.rpx,
                        child: UploadImage(
                          limit: 6,
                          imgList: controller.state.imgList,
                          spacing: 14.rpx,
                          callback: (val) {
                            controller.state.imgList = val;
                            controller.update(['upload']);
                          },
                        ),
                      ),
                      const Spacer(),
                      CommonGradientButton(
                        height: 50.rpx,
                        text: S.current.confirmUpload,
                        onTap: controller.updateInfoImage,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
