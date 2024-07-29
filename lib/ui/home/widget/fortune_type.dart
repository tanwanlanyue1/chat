
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/home/widget/answer_star_sign.dart';
import 'package:guanjia/widgets/app_image.dart';

///运势分类
class FortuneType extends StatelessWidget {
  Map item;
  FortuneType({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return item['parameter'] == null?
    fortune():
    history();
  }

  //运势
  Widget fortune(){
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
            Row(
              children: [
                Text('姓名:',style: TextStyle(color: Color(0xff666666),fontSize: 14.rpx),),
                Text(' ${item['quiz']['name']}',style: TextStyle(fontSize: 14.rpx)),
                SizedBox(width: 24.rpx,),
                Text('性别:',style: TextStyle(color: Color(0xff666666),fontSize: 14.rpx)),
                Text('${item['quiz']['sex']}',style: TextStyle(fontSize: 14.rpx)),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 8.rpx,bottom: 8.rpx),
              child: Row(
                children: [
                  Text('出生时辰:',style: TextStyle(color: Color(0xff666666),fontSize: 14.rpx),),
                  Text(' ${item['quiz']['birthday']}',style: TextStyle(fontSize: 14.rpx)),
                ],
              ),
            ),
            Text('${item['quiz']['type']}',style: TextStyle(fontSize: 14.rpx,color: Color(0xff8D310F))),
          ],
        )
    );
  }

  //历史
  Widget history(){
    var parameter = jsonDecode(item['parameter']);
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(parameter['birthday']);
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
            Row(
              children: [
                Visibility(
                  visible: parameter['name'] != '',
                  child: Text('姓名:',style: TextStyle(color: Color(0xff666666),fontSize: 14.rpx),),
                ),
                Visibility(
                  visible: parameter['name'] != '',
                  child: Text(' ${parameter['name']}',style: TextStyle(fontSize: 14.rpx)),
                ),
                SizedBox(width: 24.rpx,),
                Text('性别:',style: TextStyle(color: Color(0xff666666),fontSize: 14.rpx)),
                Text('${parameter['sex']}',style: TextStyle(fontSize: 14.rpx)),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 8.rpx,bottom: 8.rpx),
              child: Row(
                children: [
                  Text('出生时辰:',style: TextStyle(color: Color(0xff666666),fontSize: 14.rpx),),
                  Text(' ${DateFormat('yyyy年MM月dd日 HH时').format(dateTime)}',style: TextStyle(fontSize: 14.rpx)),
                ],
              ),
            ),
            Text('${parameter['typeStr']}',style: TextStyle(fontSize: 14.rpx,color: Color(0xff8D310F))),
          ],
        )
    );
  }
}
