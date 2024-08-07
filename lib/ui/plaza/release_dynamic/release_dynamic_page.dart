import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:guanjia/widgets/input_widget.dart';
import 'package:guanjia/widgets/upload_image.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

import '../widgets/publish_success.dart';
import 'release_dynamic_controller.dart';

///发布动态
class ReleaseDynamicPage extends StatelessWidget {
  ReleaseDynamicPage({Key? key}) : super(key: key);

  final controller = Get.put(ReleaseDynamicController());
  final state = Get.find<ReleaseDynamicController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("新帖子"),
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
          padding: EdgeInsets.only(top: 12.rpx,bottom: 16.rpx),
          margin: EdgeInsets.only(top: 12.rpx),
          color: Colors.white,
          child: InputWidget(
              hintText: '请输入内容',
              fillColor: Colors.white,
              maxLength: 100,
              lines: 8,
              onChanged: (val) {
                print("val===$val");
              }
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 2.rpx),
          padding: EdgeInsets.only(left: 16.rpx,top: 16.rpx),
          color: Colors.white,
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              text: '上传照片',
              style: AppTextStyle.fs16m.copyWith(color: AppColor.gray5),
              children: <TextSpan>[
                TextSpan(
                  text: '(最多9张)',
                  style: AppTextStyle.fs14m.copyWith(color: AppColor.red53,),
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
              imgList: [],
              // imgList: controller.state.imgList,
              callback: (val) {
                // controller.state.imgList = val;
                // controller.update(['upload']);
              },
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(bottom: Get.mediaQuery.padding.bottom,left: 38.rpx,right: 38.rpx,top: 14.rpx),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 12.0), //阴影xy轴偏移量
                  blurRadius: 15.0, //阴影模糊程度
                  spreadRadius: 4.0 //阴影扩散程度
              ),
            ],
          ),
          child: CommonGradientButton(
            onTap: (){
              PublishSuccess.show();
            },
            height: 50.rpx,
            text: "立即发布",
          ),
        ),
      ],
    );
  }

}
