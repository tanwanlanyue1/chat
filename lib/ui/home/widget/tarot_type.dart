
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/home/widget/answer_star_sign.dart';
import 'package:guanjia/widgets/app_image.dart';

///塔罗牌-提问
class TarotType extends StatelessWidget {
  Map item;
  TarotType({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return  item['parameter'] == null?
    tarotWidget():
    history();
  }

  //塔罗牌
  Widget tarotWidget(){
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(item['quiz']['tarot'].length, (i){
                  var url = '${item['quiz']['tarot'][i]['url']}${item['quiz']['tarot'][i]['name']}.png';
                  return Column(
                    children: [
                      AppImage.network(url,width: 50.rpx,height: 80.rpx,),
                      Text('${item['quiz']['tarot'][i]['name']}',style: AppTextStyle.fs14b.copyWith(color: AppColor.gray5,height: 2),),
                      Text(i == 0 ? '过去': i == 1 ? "现在":"未来",style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),),
                    ],
                  );
                }),
            ),
            SizedBox(height: 8.rpx,),
            Text('困惑: ${item['quiz']['name'] == '' ? '说出困惑，修行之路不迷茫' : item['quiz']['name']}',style: AppTextStyle.fs14m.copyWith(color: AppColor.primary),),
          ],
        )
    );
  }

  //历史
  Widget history(){
    var parameter = jsonDecode(item['parameter']);
   List<String> tarot = parameter['tarot'].split(',');
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(tarot.length, (i){
                var url = '${parameter['url']}${tarot[i]}.png';
                return Column(
                  children: [
                    AppImage.network(url,width: 50.rpx,height: 80.rpx,),
                    Text(tarot[i],style: AppTextStyle.fs14b.copyWith(color: AppColor.gray5,height: 2),),
                    Text(i == 0 ? '过去': i == 1 ? "现在":"未来",style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),),
                  ],
                );
              }),
            ),
            SizedBox(height: 8.rpx,),
            Text('困惑: ${parameter['question'] == '' ? '说出困惑，修行之路不迷茫' : parameter['question']}',style: AppTextStyle.fs14m.copyWith(color: AppColor.primary),),
          ],
        )
    );
  }
}
