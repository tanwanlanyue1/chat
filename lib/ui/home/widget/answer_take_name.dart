
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

import '../../../common/network/api/model/talk_model.dart';

///取名-回答
class AnswerTakeName extends StatelessWidget {
  Map item;
  AnswerTakeName({super.key,required this.item});

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
      takeName():
      history()
    );
  }

  Widget takeName(){
    return Column(
      children: List.generate(item['answer'].length, (index) {
        TalkNameModel talk = item['answer'][index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 6.rpx,),
            Container(
              alignment: Alignment.centerLeft,
              child: Text('${index+1}.${talk.name}',style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),),
            ),
            Text('${talk.implication}',style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),),
          ],
        );
      }),
    );
  }

  //历史进入
  Widget history(){
    var historyData = jsonDecode(item['answer']);
    return Column(
      children: List.generate(historyData.length, (index) {
        TalkNameModel talk = TalkNameModel.fromJson(historyData[index]);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 6.rpx,),
            Container(
              alignment: Alignment.centerLeft,
              child: Text('${index+1}.${talk.name}',style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),),
            ),
            Text('${talk.implication}',style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),),
          ],
        );
      }),
    );
  }
}
