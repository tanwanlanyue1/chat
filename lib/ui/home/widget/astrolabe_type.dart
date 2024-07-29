
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

///星座-星盘
class AstrolabeType extends StatelessWidget {
  Map item;
  AstrolabeType({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return item['parameter'] == null?
    astrolabe():
    history();
  }

  //星座-星盘
  Widget astrolabe(){
    return Container(
        decoration: BoxDecoration(
            color: const Color(0xffE9E9E9),
            borderRadius: BorderRadius.all(Radius.circular(8.rpx))
        ),
        margin: EdgeInsets.only(left: 36.rpx,right: 22.rpx),
        padding: EdgeInsets.all(12.rpx),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('出生时间：${item['quiz']['time'][0]}年${item['quiz']['time'][1]}月${item['quiz']['time'][2]}日',style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),),
            Text('出生地：${item['quiz']['address']['presentAddress']}',style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),),
          ],
        )
    );
  }

  //历史
  Widget history(){
    var parameter = jsonDecode(item['parameter']);
    return Container(
        decoration: BoxDecoration(
            color: const Color(0xffE9E9E9),
            borderRadius: BorderRadius.all(Radius.circular(8.rpx))
        ),
        margin: EdgeInsets.only(left: 36.rpx,right: 22.rpx),
        padding: EdgeInsets.all(12.rpx),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('出生时间：${parameter['year']}年${parameter['month']}月${parameter['day']}日',style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),),
            Text('出生地：${parameter['province']}${parameter['city']}',style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),),
          ],
        )
    );
  }
}
