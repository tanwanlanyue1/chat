import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

class ExamineButton extends StatefulWidget {
  final int costGold;//境修币
  final EdgeInsetsGeometry? margin;//边距
  final Function()? callBack;//点击回调
  const ExamineButton({super.key,required this.costGold,this.callBack,this.margin});

  @override
  State<ExamineButton> createState() => _ExamineButtonState();
}

class _ExamineButtonState extends State<ExamineButton> {

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                image: AppDecorations.backgroundImage(
                    'assets/images/disambiguation/symbols.png'
                ),
              ),
              height: 40.rpx,
              width: 140.rpx,
              alignment: Alignment.center,
              margin: widget.margin ?? EdgeInsets.only(top: 20.rpx, bottom: 20.rpx),
              child: Visibility(
                visible: widget.costGold != 0,
                replacement: Text('限时免费',style: AppTextStyle.fs18b.copyWith(color: AppColor.brown28),),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppImage.asset(
                      'assets/images/disambiguation/repair.png',
                      width: 20.rpx,
                      height: 20.rpx,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 4.rpx,right: 2.rpx),
                      child: Text('x${widget.costGold}',style: AppTextStyle.fs20b.copyWith(color: AppColor.brown28,height: 1),),
                    ),
                    Text('解锁',style: AppTextStyle.fs18b.copyWith(color: AppColor.brown28,height: 1.0),),
                  ],
                ),
              ),
            ),
            onTap: () {widget.callBack?.call();},
          )
        ],
      );
  }
}
