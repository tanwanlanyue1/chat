
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';

///周易六爻-回答
class AnswerSixYao extends StatelessWidget {
  Map item;
  AnswerSixYao({super.key,required this.item});

  /// 卦象
  List divination = [
    {'name':"少阴","type": '0','icon':"assets/images/home/shao_yin_a.png"},
    {'name':"老阴","type": '2','icon':"assets/images/home/lao_yin_a.png"},
    {'name':"少阳","type": '1','icon':"assets/images/home/shao_yang_a.png"},
    {'name':"老阳","type": '3','icon':"assets/images/home/lao_yang_a.png"}
  ];
  late List<String> digits;

  String yaoIcon(String str){
    for (var element in divination) {
      if(element['type'] == str){
        return element['icon'];
      }
    }
    return '';
  }

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
      sixYao():
      history()
    );
  }

  //提问进入
  Widget sixYao(){
    digits = item['quiz']['yao'].split(',');
    return Column(
      children: [
        SizedBox(height: 8.rpx,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(digits.length, (i) {
            return Container(
              margin: EdgeInsets.only(bottom: 10.rpx),
              width: 196.rpx,
              alignment: Alignment.centerLeft,
              child: AppImage.asset(yaoIcon(digits[i]),height: 12.rpx,),
            );
          }),
        ),
        SizedBox(height: 10.rpx,),
        Text('时辰${item['answer']['basicInfo']}',style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),),
        Padding(
          padding: EdgeInsets.only(top: 6.rpx,bottom: 6.rpx),
          child: Text('伏羲先天六十四卦-解读',style: AppTextStyle.fs16b.copyWith(color: AppColor.gray5),),
        ),
        Text('${item['answer']['fuXiHexagrams']}',style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),),
        Padding(
          padding: EdgeInsets.only(top: 6.rpx,bottom: 6.rpx),
          child: Text('周易后天六十四卦-解读',style: AppTextStyle.fs16b.copyWith(color: AppColor.gray5),),
        ),
        Text('${item['answer']['zhouYiHexagrams']}',style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),),
      ],
    );
  }

  //历史记录进入
  Widget history(){
    Map historyData = jsonDecode(item['answer']);
    Map parameter = jsonDecode(item['parameter']);
    return Column(
      children: [
        SizedBox(height: 8.rpx,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(parameter['yao']?.length ?? 0, (i) {
            return Container(
              margin: EdgeInsets.only(bottom: 10.rpx),
              width: 196.rpx,
              alignment: Alignment.centerLeft,
              child: AppImage.asset(yaoIcon(parameter['yao'][i]),height: 12.rpx,),
            );
          }),
        ),
        SizedBox(height: 10.rpx,),
        Text('时辰${historyData['basicInfo']}',style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),),
        Padding(
          padding: EdgeInsets.only(top: 6.rpx,bottom: 6.rpx),
          child: Text('伏羲先天六十四卦-解读',style: AppTextStyle.fs16b.copyWith(color: AppColor.gray5),),
        ),
        Text('${historyData['fuXiHexagrams']}',style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),),
        Padding(
          padding: EdgeInsets.only(top: 6.rpx,bottom: 6.rpx),
          child: Text('周易后天六十四卦-解读',style: AppTextStyle.fs16b.copyWith(color: AppColor.gray5),),
        ),
        Text('${historyData['zhouYiHexagrams']}',style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),),
      ],
    );
  }
}
