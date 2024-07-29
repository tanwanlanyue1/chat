
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/star.dart';

///星座分类
class ProblemStarType extends StatelessWidget {
  Map item;
  ProblemStarType({super.key, required this.item});

  Map? starType(String name){
    for (var element in Star.starSignList) {
      if(element.name == name){
        return {
          "time": element.time,
          "icon": element.icon,
        };
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return item['parameter'] == null?
    starSign():
    history();
  }

  //星座-运势
  Widget starSign(){
    return Container(
      decoration: BoxDecoration(
          color: AppColor.gray20,
          borderRadius: BorderRadius.all(Radius.circular(8.rpx))
      ),
      margin: EdgeInsets.only(left: 36.rpx,right: 22.rpx),
      padding: EdgeInsets.all(12.rpx),
      child: Row(
        children: [
          Container(
            width: 60.rpx,
            height: 60.rpx,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8.rpx))
            ),
            margin: EdgeInsets.only(right: 11.rpx),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppImage.asset(
                  item['quiz']['constellation'].icon,
                  width: 20.rpx,
                  height: 20.rpx,
                ),
                Text("${item['quiz']['constellation'].name}",style: AppTextStyle.fs14m.copyWith(color: AppColor.brown26),),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${item['quiz']['constellation'].name}  ${item['quiz']['constellation'].time}",style: AppTextStyle.fs14b.copyWith(color: AppColor.gray5),),
              Text("${item['quiz']['time']}运势",style: AppTextStyle.fs14m.copyWith(color: AppColor.red1),),
            ],
          )
        ],
      ),
    );
  }

  //历史
  Widget history(){
    var parameter = jsonDecode(item['parameter']);
    return Container(
      decoration: BoxDecoration(
          color: AppColor.gray20,
          borderRadius: BorderRadius.all(Radius.circular(8.rpx))
      ),
      margin: EdgeInsets.only(left: 36.rpx,right: 22.rpx),
      padding: EdgeInsets.all(12.rpx),
      child: Row(
        children: [
          Container(
            width: 60.rpx,
            height: 60.rpx,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8.rpx))
            ),
            margin: EdgeInsets.only(right: 11.rpx),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppImage.asset(
                  starType(parameter['constellationStr'])?['icon'],
                  width: 20.rpx,
                  height: 20.rpx,
                ),
                Text("${parameter['constellationStr']}",style: AppTextStyle.fs14m.copyWith(color: AppColor.brown26),),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${parameter['constellationStr']}  ${starType(parameter['constellationStr'])?['time']}",style: AppTextStyle.fs14b.copyWith(color: AppColor.gray5),),
              Text("${parameter['timeTypeStr']}运势",style: AppTextStyle.fs14m.copyWith(color: AppColor.red1),),
            ],
          )
        ],
      ),
    );
  }
}
