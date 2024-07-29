import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';

///六爻-提问
class YaoType extends StatelessWidget {
  Map item;
  YaoType({super.key, required this.item});

  /// 卦象
  List divination = [
    {'name':"少阴","type": '0','icon':"assets/images/home/shao_yin.png"},
    {'name':"老阴","type": '2','icon':"assets/images/home/lao_yin.png"},
    {'name':"少阳","type": '1','icon':"assets/images/home/shao_yang.png"},
    {'name':"老阳","type": '3','icon':"assets/images/home/lao_yang.png"}
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

  String yaoName(int index){
    if(index == 0){
      return '一';
    }else if(index == 1){
      return '二';
    }else if(index == 2){
      return '三';
    }else if(index == 3){
      return '四';
    }else if(index == 4){
      return '五';
    }else if(index == 5){
      return '六';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return  item['parameter'] == null?
    sixYao():
    history();
  }

  //yao
  Widget sixYao(){
    digits = item['quiz']['yao'].split(',');
    return Container(
        decoration: BoxDecoration(
            color: const Color(0xffE9E9E9),
            borderRadius: BorderRadius.all(Radius.circular(8.rpx))
        ),
        margin: EdgeInsets.only(left: 36.rpx,right: 22.rpx),
        padding: EdgeInsets.all(12.rpx),
        width: 260.rpx,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 24.rpx,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: digits.length,
                itemBuilder: (_, i) {
                  return Row(
                    children: [
                      Text('第${yaoName(i)}爻: ',style: TextStyle(color: AppColor.gray5,fontSize: 14.rpx),),
                      Padding(
                        padding: EdgeInsets.only(top: 4.rpx,left: 4.rpx),
                        child: AppImage.asset(yaoIcon(digits[i]),width: 48.rpx,height: 12.rpx,),
                      )
                    ],
                  );
                }
            ),
            SizedBox(height: 8.rpx,),
            Text('困惑: ${item['quiz']['name'] == '' ? '说出困惑，修行之路不迷茫' : item['quiz']['name']}',style: AppTextStyle.fs14m.copyWith(color: AppColor.primary),),
          ],
        )
    );
  }

  //历史
  Widget history(){
    return Container(
        decoration: BoxDecoration(
            color: const Color(0xffE9E9E9),
            borderRadius: BorderRadius.all(Radius.circular(8.rpx))
        ),
        margin: EdgeInsets.only(left: 36.rpx,right: 22.rpx),
        padding: EdgeInsets.all(12.rpx),
        width: 260.rpx,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 24.rpx,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 6,
                itemBuilder: (_, i) {
                  return Row(
                    children: [
                      Text('第${yaoName(i)}爻: ',style: TextStyle(color: AppColor.gray5,fontSize: 14.rpx),),
                      Padding(
                        padding: EdgeInsets.only(top: 4.rpx,left: 4.rpx),
                        child: AppImage.asset(yaoIcon(jsonDecode(item['parameter'])['yao'][i]),width: 48.rpx,height: 12.rpx,),
                      )
                    ],
                  );
                }
            ),
            SizedBox(height: 8.rpx,),
            Text('困惑: ${jsonDecode(item['parameter'])['question'] == '' ? '说出困惑，修行之路不迷茫' : jsonDecode(item['parameter'])['question']}',style: AppTextStyle.fs14m.copyWith(color: AppColor.primary),),
          ],
        )
    );
  }
}
