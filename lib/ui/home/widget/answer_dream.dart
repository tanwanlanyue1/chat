
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

///解梦-回答
class AnswerDream extends StatelessWidget {
  Map item;
  AnswerDream({super.key,required this.item});

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
      dream():
      history(),
    );
  }

  //
  Widget dream(){
    return Column(
      children: List.generate(item['answer'].length, (index) {
        var answer = item['answer'][index];
        return Container(
          padding: EdgeInsets.only(bottom: 8.rpx),
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${answer['title']}',style: AppTextStyle.fs16b.copyWith(color: AppColor.gray5),),
              Text('${answer['content']}',style: AppTextStyle.fs14m.copyWith(color: AppColor.gray9),),
            ],
          ),
        );
      }),
    );
  }

  //历史进入
  Widget history(){
    var historyData = jsonDecode(item['answer']);
    return Column(
      children: List.generate(historyData.length, (index) {
        var answer = historyData[index];
        return Container(
          padding: EdgeInsets.only(bottom: 8.rpx),
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${answer['title']}',style: AppTextStyle.fs16b.copyWith(color: AppColor.gray5),),
              Text('${answer['content']}',style: AppTextStyle.fs14m.copyWith(color: AppColor.gray9),),
            ],
          ),
        );
      }),
    );
  }
}
