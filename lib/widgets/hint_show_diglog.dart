import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

///提示弹窗
Future<T?> HintShowDiglog<T>({
  String? title = '提示',
  String? contentText,
  Widget? content,
  String textConfirm = '确定',
  String? textCancel = '取消',
  Color? confirmColor,
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
  bool barrierDismissible = false,
}) {
  if (((contentText?.isEmpty ?? true) && null == content) || ((contentText?.isNotEmpty ?? false) && null != content)) {
    assert(false, 'contentText和content只能二選一，且不能都为空');
  }

  final actionBtnWidth = 40.rpx;
  final actionBtnHeight = 36.rpx;
  final hasTitle = title?.isNotEmpty ?? false;
  final hasCancelBtn = null != textCancel;

  Widget alert = DefaultTextStyle.merge(
    style: const TextStyle(
      fontWeight: FontWeight.w500,
    ),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(12.rpx),
        ),
      ),
      clipBehavior: Clip.hardEdge,
      padding: EdgeInsets.symmetric(
        horizontal: 26.rpx,
        vertical: 20.rpx,
      ),
      width: 287.rpx,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasTitle)
            Text(
              title ?? '',
              style: TextStyle(
                fontSize: 18.rpx,
                color: Color(0xFF262626)
              ),
            ),
          if (hasTitle)
            SizedBox(
              height: 12.rpx,
            ),
          content ??
          Text(
            contentText!,
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 14.rpx,
                color: Color(0xFF262626)
            ),
          ),
          SizedBox(
            height: 10.rpx,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              !hasCancelBtn
                  ? Container()
                  : GestureDetector(
                onTap: (){
                  Get.back();
                  if (null != onCancel) {
                    onCancel();
                  }
                },
                child: Container(
                  width: actionBtnWidth,
                  height: actionBtnHeight,
                  alignment: Alignment.center,
                  child: Text(
                    textCancel,
                    style: TextStyle(
                        fontSize: 14.rpx,
                        color: Color(0xFF666666)
                    ),
                  ),
                ),
              ),
                    GestureDetector(
                    onTap: (){
                      Get.back();

                      if (null != onConfirm) {
                        onConfirm();
                      }
                    },
                    child: Container(
                      width: actionBtnWidth,
                      height: actionBtnHeight,
                      alignment: Alignment.center,
                      child: Text(
                        textConfirm,
                        style: TextStyle(
                            fontSize: 14.rpx,
                            color: Color(0xFF666666)
                        ),
                      ),
                    ),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  return Get.dialog(
    AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: content ?? alert,
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12.rpx),
        ),
      ),
      backgroundColor: Colors.transparent,
    ),
    barrierDismissible: barrierDismissible,
  );
}
