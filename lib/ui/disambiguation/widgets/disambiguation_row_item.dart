import 'package:flutter/material.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

///表单常用样式
///titleColor:标题颜色
///title:标题
///alignStart:居上
///child:右边内容
///expanded:右边默认占据全部
class DisambiguationRowItem extends StatelessWidget {
  final Color? titleColor;
  final bool alignStart;
  final bool margin;
  final bool padding;
  final bool expanded;
  final bool expandedLeft;
  final String? title;
  final double? height;
  final Widget child;
  final BoxDecoration? decoration;
  const DisambiguationRowItem({super.key, required this.child, this.height,this.title, this.titleColor, this.alignStart = false, this.margin = true, this.padding = false,this.decoration,this.expanded = true,this.expandedLeft = false,});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        margin: margin ? EdgeInsets.only(top: 6.rpx,bottom: 6.rpx) : EdgeInsets.zero,
        padding: padding ? EdgeInsets.only(bottom: 8.rpx) : EdgeInsets.zero,
        decoration: decoration,
        child: Row(
            crossAxisAlignment: alignStart ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Visibility(
                visible: expandedLeft,
                replacement: SizedBox(
                    width: 75.rpx,
                    child: Text(
                      '$title',
                      textAlign: TextAlign.justify,
                      style: AppTextStyle.fs14b.copyWith(
                        color: titleColor ?? Colors.black,
                      ),
                      maxLines: 1,
                    )
                ),
                child: Expanded(
                  child: SizedBox(
                      child: Text(
                        '$title',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            color: titleColor ?? const Color(0XFF969799),
                            fontSize: 14.rpx,
                            fontWeight: FontWeight.w500
                        ),
                      )
                  ),
                ),
              ),
              expanded ? Expanded(child: child) : child
            ]
        )
    );
  }
}
