import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/decimal_text_input_formatter.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/plaza/release_media/media_upload/media_upload_view.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:guanjia/widgets/input_widget.dart';
import 'package:guanjia/widgets/upload_image.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

import 'release_media_controller.dart';

///发布私房照
class ReleaseMediaPage extends StatelessWidget {
  ReleaseMediaPage({Key? key}) : super(key: key);

  final controller = Get.put(ReleaseMediaController());
  final state = Get.find<ReleaseMediaController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('发布私房照'),
      ),
      body: buildBody(),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          bottom: Get.mediaQuery.padding.bottom + 14.rpx,
          left: 38.rpx,
          right: 38.rpx,
          top: 14.rpx,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 12.0),
                blurRadius: 15.0,
                spreadRadius: 4.0),
          ],
        ),
        child: CommonGradientButton(
          onTap: controller.onSubmit,
          height: 50.rpx,
          text: S.current.publishNow,
        ),
      ),
    );
  }

  Widget buildBody() {
    return ListView(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(top: 12.rpx),
          margin: EdgeInsets.only(top: 12.rpx),
          color: Colors.white,
          child: InputWidget(
            hintText: S.current.pleaseEnterContent,
            inputController: controller.contentEditingController,
            fillColor: Colors.white,
            maxLength: 100,
            counterText: '',
            lines: 7,
            keyboardType: TextInputType.multiline,
            textAction: TextInputAction.newline,
            onChanged: (val) {
              controller.update(['textLength']);
            },
          ),
        ),
        GetBuilder<ReleaseMediaController>(
          id: 'textLength',
          builder: (_) {
            return Container(
              padding: EdgeInsets.only(right: 16.rpx, bottom: 16.rpx),
              alignment: Alignment.centerRight,
              color: Colors.white,
              child: RichText(
                text: TextSpan(
                  text: '${controller.contentEditingController.text.length}',
                  style: AppTextStyle.fs14.copyWith(color: AppColor.red),
                  children: <TextSpan>[
                    TextSpan(
                      text: "/100",
                      style: AppTextStyle.fs14.copyWith(
                        color: AppColor.black999,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        Container(
          margin: EdgeInsets.only(top: 2.rpx),
          padding: EdgeInsets.only(left: 16.rpx, top: 16.rpx),
          color: Colors.white,
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              text: '上传图片或视频',
              style: AppTextStyle.fs16.copyWith(color: AppColor.gray5),
              children: <TextSpan>[
                TextSpan(
                  text: '（最多9张图片/1个视频）',
                  style: AppTextStyle.fs14.copyWith(
                    color: AppColor.red,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 12.rpx, top: 12.rpx),
          color: Colors.white,
          alignment: Alignment.topLeft,
          child: MediaUploadView(
            onChanged: (list) {
              state.mediaList
                ..clear()
                ..addAll(list);
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16.rpx, top: 16.rpx),
          child: Text('解锁查看'),
        ),
        buildUnlockOptions(),
      ],
    );
  }

  Widget buildUnlockOptions() {
    return Obx((){
      final isFree = state.isFreeRx();
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text('免费公开'),
            leading: Radio<bool>(
              value: true,
              groupValue: isFree,
              onChanged: (value){
                state.isFreeRx.value = value ?? true;
              },
            ),
          ),
          ListTile(
            title: const Text('需打赏'),
            leading: Radio<bool>(
              value: false,
              groupValue: isFree,
              onChanged: (value){
                state.isFreeRx.value = value ?? true;
              },
            ),
            trailing: SizedBox(
              width: 100.rpx,
              child: TextField(
                controller: controller.amountEditingController,
                expands: true,
                maxLines: null,
                style: AppTextStyle.fs14m.copyWith(
                  color: AppColor.black3,
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  signed: false,
                  decimal: true,
                ),
                inputFormatters: [
                  DecimalTextInputFormatter(
                      decimalDigits: SS.appConfig.decimalDigits,
                      maxValue: 9999999,
                      maxValueHint: S.current.amountMaxLimitExceed
                  )
                ],
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: '打赏金额',
                  hintStyle: AppTextStyle.fs14.copyWith(color: AppColor.black9),
                  contentPadding: FEdgeInsets(horizontal: 12.rpx),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
