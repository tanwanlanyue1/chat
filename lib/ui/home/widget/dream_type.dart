
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/home/widget/answer_star_sign.dart';
import 'package:guanjia/widgets/app_image.dart';

///解梦-提问
class DreamType extends StatelessWidget {
  Map item;
  DreamType({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return item['parameter'] == null?
    oneiromancy():
    history();
  }

  //解梦
  Widget oneiromancy(){
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xffE9E9E9),
          borderRadius: BorderRadius.all(Radius.circular(8.rpx))
      ),
      margin: EdgeInsets.only(left: 36.rpx,right: 22.rpx),
      padding: EdgeInsets.all(12.rpx),
      width: 240.rpx,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('性别:',style: TextStyle(color: const Color(0xff666666),fontSize: 14.rpx)),
              Text('${item['quiz']['sex']}',style: TextStyle(fontSize: 14.rpx)),
            ],
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 8.rpx,bottom: 8.rpx),
              alignment: Alignment.center,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('梦境:',style: TextStyle(color: const Color(0xff666666),fontSize: 14.rpx),),
                  Expanded(
                    child: Text(' ${item['quiz']['name']}',style: TextStyle(fontSize: 14.rpx)),
                  ),
                ],
              ),
            ),
          ),
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
        width: 240.rpx,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('性别:',style: TextStyle(color: const Color(0xff666666),fontSize: 14.rpx)),
                Text('${parameter['sex']}',style: TextStyle(fontSize: 14.rpx)),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 8.rpx,bottom: 8.rpx),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('梦境:',style: TextStyle(color: const Color(0xff666666),fontSize: 14.rpx),),
                  Expanded(
                    child: Text(' ${parameter['content']}',style: TextStyle(fontSize: 14.rpx)),
                  ),
                ],
              ),
            ),
          ],
        )
    );
  }
}
