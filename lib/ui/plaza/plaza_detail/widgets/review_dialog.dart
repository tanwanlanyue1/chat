import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

import '../plaza_detail_controller.dart';

///评论回复对话框
///callBack回调，消息回复中使用
class ReviewDialog extends StatelessWidget {
  final void Function(String? str)? callBack;
  ReviewDialog({super.key,this.callBack});
  late PlazaDetailController controller;

  ///发布成功后返回true,否则返回null
  static Future<bool?> show({ Function(String? str)? callBack}) {
    return Get.dialog<bool>(
      ReviewDialog(
        callBack: callBack,
      ),
    );
  }

  final TextEditingController textController = TextEditingController();
  FocusNode chatFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    if(callBack == null){
      controller = Get.find<PlazaDetailController>();
    }else{
      chatFocusNode.requestFocus();
    }
    return GestureDetector(
      onTap: (){
        Get.back();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        body: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 60.rpx,
            color: Colors.white,
            padding: EdgeInsets.only(right: 15.rpx,left: 12.rpx),
            child: Row(
              children: [
                callBack == null ?
                Expanded(
                  child: TextField(
                    controller: controller.chatController,
                    focusNode: controller.chatFocusNode,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xffF6F6F6),
                      hintText: (controller.state.hint != null && controller.state.hint!.isNotEmpty) ? controller.state.hint : "说说我的看法",
                      hintStyle: TextStyle(
                        fontSize: 12.rpx,
                      ),
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                  ),
                ):
                Expanded(
                  child: TextField(
                    controller: textController,
                    focusNode: chatFocusNode,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xffF6F6F6),
                      hintText: "说说我的看法",
                      hintStyle: TextStyle(
                        fontSize: 12.rpx,
                      ),
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(width: 12.rpx,),
                GestureDetector(
                  onTap: (){
                    callBack == null ?
                    controller.postComment():
                    callBack?.call(textController.text);
                    },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColor.brown8,
                      borderRadius: BorderRadius.circular(18.rpx),
                    ),
                    width: 76.rpx,
                    height: 36.rpx,
                    alignment: Alignment.center,
                    child: Text("发送",style: AppTextStyle.fs14m.copyWith(color: AppColor.red1),),
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
