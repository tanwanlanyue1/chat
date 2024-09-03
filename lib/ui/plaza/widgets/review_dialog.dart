import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/common_gradient_button.dart';
import 'package:guanjia/widgets/loading.dart';

import '../../../common/network/api/api.dart';

///评论回复对话框
///callBack回调，消息回复中使用
class ReviewDialog extends StatelessWidget {
  int pid;
  final void Function(String? str)? callBack;
  ReviewDialog({super.key,this.callBack,required this.pid});

  ///发布成功后返回true,否则返回null
  static Future<bool?> show({ Function(String? str)? callBack,required int pid}) {
    return Get.dialog<bool>(
      ReviewDialog(
        pid: pid,
        callBack: callBack,
      ),
    );
  }

  ///评论
  /// pid:根评论id
  /// postId:帖子id
  Future<void> postComment() async {
      if(textController.text.isEmpty){
        Loading.showToast(S.current.pleaseEnterComment);
      }else{
        final response = await PlazaApi.postComment(
          postId: pid,
          content: textController.text,
        );
        if(response.isSuccess){
          callBack?.call(textController.text);
          Loading.showToast(response.data);
          chatFocusNode.unfocus();
          Get.back();
        }else{
          response.showErrorMessage();
        }
      }
  }

  final TextEditingController textController = TextEditingController();
  FocusNode chatFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    chatFocusNode.requestFocus();
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
                Expanded(
                  child: TextField(
                    controller: textController,
                    focusNode: chatFocusNode,
                    maxLength: 100,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xffF6F6F6),
                      hintText: S.current.writeYourComments,
                      counterText: '',
                      hintStyle: TextStyle(
                        fontSize: 12.rpx,
                      ),
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(width: 12.rpx,),
                CommonGradientButton(
                  width: 76.rpx,
                  height: 36.rpx,
                  text: S.current.send,
                  onTap: (){
                    postComment();
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
