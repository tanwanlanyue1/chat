import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:guanjia/widgets/input_widget.dart';
import 'package:guanjia/widgets/upload_image.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

import 'release_dynamic_controller.dart';

///发布动态
class ReleaseDynamicPage extends StatelessWidget {
  ReleaseDynamicPage({Key? key}) : super(key: key);

  final controller = Get.find<ReleaseDynamicController>();
  final state = Get.find<ReleaseDynamicController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.newPost),
      ),
      backgroundColor: AppColor.scaffoldBackground,
      body: buildDynamic(),
    );
  }

  ///动态
  Widget buildDynamic(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(top: 12.rpx),
          margin: EdgeInsets.only(top: 12.rpx),
          color: Colors.white,
          child: InputWidget(
              hintText: S.current.pleaseEnterContent,
              inputController: controller.contentController,
              fillColor: Colors.white,
              maxLength: 100,
              counterText: '',
              lines: 7,
              keyboardType: TextInputType.multiline,
              textAction: TextInputAction.newline,
              onChanged: (val){
                controller.update(['textLength']);
              },
          ),
        ),
        GetBuilder<ReleaseDynamicController>(
          id: 'textLength',
          builder: (_){
            return Container(
              padding: EdgeInsets.only(right: 16.rpx,bottom: 16.rpx),
              alignment: Alignment.centerRight,
              color: Colors.white,
              child: RichText(
                text: TextSpan(
                  text: '${controller.contentController.text.length}',
                  style: AppTextStyle.fs14.copyWith(color: AppColor.red),
                  children: <TextSpan>[
                    TextSpan(
                      text: "/100",
                      style: AppTextStyle.fs14.copyWith(color: AppColor.black999,),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        Container(
          margin: EdgeInsets.only(top: 2.rpx),
          padding: EdgeInsets.only(left: 16.rpx,top: 16.rpx),
          color: Colors.white,
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              text: S.current.uploadPictures,
              style: AppTextStyle.fs16.copyWith(color: AppColor.gray5),
              children: <TextSpan>[
                TextSpan(
                  text: S.current.upTo9photos,
                  style: AppTextStyle.fs14.copyWith(color: AppColor.red,),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 12.rpx),
            color: Colors.white,
            alignment: Alignment.topLeft,
            child: UploadImage(
              imgList: state.imgList,
              limit: 9,
              callback: (val) {
                controller.state.imgList = val;
                controller.update(['upload']);
              },
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(bottom: Get.mediaQuery.padding.bottom+14.rpx,left: 38.rpx,right: 38.rpx,top: 14.rpx),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 12.0),
                  blurRadius: 15.0,
                  spreadRadius: 4.0
              ),
            ],
          ),
          child: CommonGradientButton(
            onTap: controller.addCommunity,
            height: 50.rpx,
            text: S.current.publishNow,
          ),
        ),
      ],
    );
  }

}
