
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

///运势-回答
class AnswerFortune extends StatelessWidget {
  Map item;
  AnswerFortune({super.key,required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8.rpx))
      ),
      margin: EdgeInsets.only(left: 22.rpx,right: 22.rpx),
      padding: EdgeInsets.all(12.rpx),
      child: item['parameter'] == null?
      fortune():
      history(),
    );
  }

  //运势
  Widget fortune(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 8.rpx,bottom: 8.rpx),
          child: Text('八字命盘信息',style: AppTextStyle.fs16b.copyWith(color: AppColor.gray5),),
        ),
        Text('${item['answer'].bazi}',style: AppTextStyle.fs14m.copyWith(color: AppColor.gray9),),
        Container(
          margin: EdgeInsets.only(top: 8.rpx,bottom: 8.rpx),
          child: Text('${item['quiz']['type']}',style: AppTextStyle.fs16b.copyWith(color: AppColor.gray5),),
        ),
        Text('${item['answer'].result}',style: AppTextStyle.fs14m.copyWith(color: AppColor.gray9),),
      ],
    );
  }
  //历史进入
  Widget history(){
    var historyData = jsonDecode(item['answer']);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 8.rpx,bottom: 8.rpx),
          child: Text('八字命盘信息',style: AppTextStyle.fs16b.copyWith(color: AppColor.gray5),),
        ),
        Text('${historyData['bazi']}',style: AppTextStyle.fs14m.copyWith(color: AppColor.gray9),),
        // Container(
        //   margin: EdgeInsets.only(top: 8.rpx,bottom: 8.rpx),
        //   child: Text('${item['quiz']['type']}',style: AppTextStyle.fs16b.copyWith(color: AppColor.gray5),),
        // ),
        Text('${historyData['result']}',style: AppTextStyle.fs14m.copyWith(color: AppColor.gray9),),
      ],
    );
  }
}
