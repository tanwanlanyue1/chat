import 'package:flutter/material.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

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
        SizedBox(
          width: 24.rpx,
          child: Radio(
            value: true,
            groupValue: isSelect,
            fillColor:  MaterialStateProperty.resolveWith<Color>(
            (states) {
              if (states.contains(MaterialState.selected)) {return selectColor ?? Colors.blue;}
              return unselectColor ?? const Color(0xff999999); }),
            onChanged: (bool? val) {
              titleCall?.call(val);
            },
          ),
        ),
        GestureDetector(
          child: Padding(
            padding: EdgeInsets.only(left: 6.rpx),
            child: Text(
              title,
              style: TextStyle(fontSize: 14.rpx,color: isSelect ? selectColor : unselectColor),
            ),
          ),
          onTap: (){
            titleCall?.call(true);
          },
        ),
        Container(
          width: 35.rpx,
          margin: EdgeInsets.only(left: left.rpx),
          child: Radio(
            value: false,
            groupValue: isSelect,
            fillColor:  MaterialStateProperty.resolveWith<Color>(
                    (states) {
                      if (states.contains(MaterialState.selected)) {return selectColor ?? Colors.blue;}
                      return unselectColor ?? const Color(0xff999999); }),
            onChanged: (bool? val) {
              titleCall?.call(val);
            },
          ),
        ),
        GestureDetector(
          child: Text(
            titleFalse,
            style: TextStyle(fontSize: 14.rpx,color: isSelect ? unselectColor : selectColor),
          ),
          onTap: (){
            titleCall?.call(false);
          },
        )
      ],
    );
  }
}
