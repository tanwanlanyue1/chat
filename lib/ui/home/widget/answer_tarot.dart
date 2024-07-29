
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

///塔罗牌-回答
class AnswerTarot extends StatelessWidget {
  Map item;
  AnswerTarot({super.key,required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8.rpx))
      ),
      margin: EdgeInsets.only(left: 22.rpx,right: 22.rpx),
      padding: EdgeInsets.all(12.rpx),
      child: Column(
        children: [
          Text('塔罗牌解读',style: AppTextStyle.fs16b.copyWith(color: AppColor.gray5),),
          Text('解释每张牌的含义以及它们可能对近期考虑事情的结果产生的影响:',style: AppTextStyle.fs14m.copyWith(color: AppColor.gray9),),
          item['parameter'] == null ?
          Column(
            children: List.generate(item['answer'].length, (index) {
              return Container(
                margin: EdgeInsets.only(bottom: 20.rpx,top: 6.rpx),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${index == 0 ? '过去':index == 1 ? '现在':'未来'}: ${item['quiz']['tarot'][index]['name']}',style: AppTextStyle.fs16b.copyWith(color: AppColor.gray5),),
                    Text('${item['answer'][index]}',style: AppTextStyle.fs14m.copyWith(color: AppColor.gray9),),
                  ],
                ),
              );
            }),
          ):
          Column(
            children: List.generate(jsonDecode(item['answer']).length, (index) {
              return Container(
                margin: EdgeInsets.only(bottom: 20.rpx,top: 6.rpx),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${index == 0 ? '过去':index == 1 ? '现在':'未来'}: ${jsonDecode(item['parameter'])['tarot'].split(',')[index]}',style: AppTextStyle.fs16b.copyWith(color: AppColor.gray5),),
                    Text('${jsonDecode(item['answer'])[index]}',style: AppTextStyle.fs14m.copyWith(color: AppColor.gray9),),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

}
