import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/utils/common_utils.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/input_widget.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

import 'update_info_controller.dart';

///更新昵称/个性签名页
///type:0昵称，1个性签名
class UpdateInfoPage extends StatelessWidget {
  final int type;
  UpdateInfoPage({Key? key, required this.type}) : super(key: key);

  final controller = Get.put(UpdateInfoController());
  final state = Get.find<UpdateInfoController>().state;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UpdateInfoController>(
      builder: (_) {
        return Scaffold(
          backgroundColor: const Color(0xffF6F8FE),
          appBar: AppBar(
            title: Text(
              type == 0 ? "设置昵称" : "设置签名",
              style: TextStyle(
                color: const Color(0xff333333),
                fontSize: 18.rpx,
              ),
            ),
            actions: [
              GestureDetector(
                onTap: state.canSave ? () => controller.onTapSave(type) : null,
                child: Container(
                  width: 80.rpx,
                  alignment: Alignment.center,
                  child: Text(
                    "保存",
                    style: TextStyle(
                        color: state.canSave
                            ? const Color(0xff8D310F)
                            : const Color(0xffDDC2B7),
                        fontSize: 14.rpx),
                  ),
                ),
              )
            ],
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 16.rpx, left: 12.rpx, right: 12.rpx),
            child: ListView(
              children: [
                Visibility(
                  visible: type == 0,
                  replacement: synopsis(),
                  child: nickName(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ///昵称
  Widget nickName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8.rpx),
          child: Text(
            "当前昵称：${state.nickName}",
            style: TextStyle(color: AppColor.black666, fontSize: 14.rpx),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10.rpx),
          child: InputWidget(
            hintText: '请输入您的昵称',
            lines: 1,
            fillColor: Colors.white,
            inputController: controller.textController,
            border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(8.rpx)),
            onChanged: (val) => controller.textValueChange(val),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 8.rpx, top: 12.rpx),
          child: Text(
            "昵称设置2-10个字，仅限汉字、字母、数字"
            "\n昵称代表了您在站内的形象,30天内不能再次更改\n更改昵称需要1-2个工作日审核"
            "\n昵称设置不可出现违法、时政敏感、淫秽血腥、攻击谩骂、广告等内容，请谨慎设置",
            style: TextStyle(
              color: AppColor.gray9,
              fontSize: 11.rpx,
              height: 1.9,
            ),
          ),
        ),
      ],
    );
  }

  /// 签名
  Widget synopsis() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8.rpx),
          child: Text(
            "当前签名：${state.synopsis}",
            style: TextStyle(color: Color(0xff666666), fontSize: 14.rpx),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10.rpx),
          padding: EdgeInsets.symmetric(horizontal: 12.rpx).copyWith(
            bottom: 8.rpx,
            top: 12.rpx,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.rpx),
          ),
          child: InputWidget(
            hintText: '请输入您的签名',
            maxLength: 60,
            lines: 3,
            fillColor: Colors.white,
            inputController: controller.textController,
            contentPadding: EdgeInsets.zero,
            onChanged: (val) => controller.textValueChange(val),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 8.rpx, top: 12.rpx),
          child: Text(
            "个人签名设置60个字以内\n设置个人签名需要1-2个工作日审核"
            "\n个人签名设置不可出现违法、时政敏感、淫秽血腥、攻击谩骂、广告等内容，请谨慎设置",
            style: TextStyle(
              color: AppColor.gray9,
              fontSize: 11.rpx,
              height: 1.9,
            ),
          ),
        ),
      ],
    );
  }
}
