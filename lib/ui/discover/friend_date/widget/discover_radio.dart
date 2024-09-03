import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';

///单选
///isSelect:判断的参数
///left:第二个距离第一个距离
///title：第一个单选项
///titleFalse：第二个单选项
///titleCall：点击回调
///selectColor：选中的字体颜色
///unselectColor：未选中的字体颜色
class DiscoverRadio extends StatelessWidget {
  final bool isSelect;
  final double left;
  final String title;
  final String titleFalse;
  final Color? selectColor;
  final Color? unselectColor;
  final Function(bool? val)? titleCall;
  const DiscoverRadio({super.key, required this.isSelect,required this.title,required this.titleFalse,this.left=0,this.titleCall,this.selectColor,this.unselectColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: (){
            titleCall?.call(true);
          },
          child: SizedBox(
            width: 24.rpx,
            child: AppImage.asset(
              isSelect ?
              "assets/images/discover/select.png" :
              "assets/images/discover/select_un.png",
              width: 24.rpx,
              height: 24.rpx,
              color: isSelect ? AppColor.gradientBegin : AppColor.black9,
            ),
          ),
        ),
        GestureDetector(
          child: Padding(
            padding: EdgeInsets.only(left: 6.rpx),
            child: Text(
              title,
              style: TextStyle(fontSize: 14.rpx,color: isSelect ? AppColor.black3 : AppColor.black9),
            ),
          ),
          onTap: (){
            titleCall?.call(true);
          },
        ),
        Container(
          width: 35.rpx,
          margin: EdgeInsets.only(left: left.rpx),
          child: GestureDetector(
            onTap: (){
              titleCall?.call(false);
            },
            child: AppImage.asset(
              !isSelect ?
              "assets/images/discover/select.png" :
              "assets/images/discover/select_un.png",
              width: 24.rpx,
              height: 24.rpx,
              color: !isSelect ? AppColor.gradientBegin : AppColor.black9,
            ),
          )
        ),
        GestureDetector(
          child: Text(
            titleFalse,
            style: TextStyle(fontSize: 14.rpx,color: isSelect ? AppColor.black9 : AppColor.black3),
          ),
          onTap: (){
            titleCall?.call(false);
          },
        )
      ],
    );
  }
}
