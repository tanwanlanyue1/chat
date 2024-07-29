
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guanjia/common/utils/common_utils.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

///取名问题
class TakeNameType extends StatelessWidget {
  Map item;
  TakeNameType({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return item['parameter'] == null?
    takeName():
    history();
  }

  //取名
  Widget takeName(){
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
                Text('姓氏:',style: TextStyle(color: const Color(0xff666666),fontSize: 14.rpx),),
                Text(' ${item['quiz']['name']}',style: TextStyle(fontSize: 14.rpx)),
                SizedBox(width: 24.rpx,),
                Visibility(
                  visible: item['quiz']['sex'] != '',
                  child: Text('性别:',style: TextStyle(color: const Color(0xff666666),fontSize: 14.rpx)),
                ),
                Visibility(
                  visible: item['quiz']['sex'] != '',
                  child: Text('${item['quiz']['sex']}',style: TextStyle(fontSize: 14.rpx)),
                ),
                Visibility(
                  visible: item['quiz']['sex'] != '',
                  child: SizedBox(width: 24.rpx,),
                ),
                Text('${item['quiz']['birth']}',style: TextStyle(fontSize: 14.rpx)),
              ],
            ),
            SizedBox(height: 12.rpx,),
            Visibility(
              visible: item['quiz']['birthday'] != '',
              child: Row(
                children: [
                  Text('出生时辰:',style: TextStyle(color: const Color(0xff666666),fontSize: 14.rpx),),
                  Text(' ${item['quiz']['birthday']}',style: TextStyle(fontSize: 14.rpx)),
                ],
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('姓氏:',style: TextStyle(color: const Color(0xff666666),fontSize: 14.rpx),),
                Text(' ${parameter['xing']}',style: TextStyle(fontSize: 14.rpx)),
                SizedBox(width: 24.rpx,),
                Visibility(
                  visible: parameter['sex'] != null && parameter['sex'] != '' ,
                  child: Text('性别:',style: TextStyle(color: const Color(0xff666666),fontSize: 14.rpx)),
                ),
                Visibility(
                  visible: parameter['sex'] != null && parameter['sex'] != '' ,
                  child: Text(parameter['sex'] == '1' ? '男' :'女',style: TextStyle(fontSize: 14.rpx)),
                ),
                Visibility(
                  visible: parameter['sex'] != null && parameter['sex'] != '' ,
                  child: SizedBox(width: 24.rpx,),
                ),
                Text('${parameter['birthday'] ?? '未出生'}',style: TextStyle(fontSize: 14.rpx)),
              ],
            ),
            SizedBox(height: 12.rpx,),
            //农历
            parameter['birthday'] != null && parameter['birthday'] != ''?
            Row(
              children: [
                Text('出生时辰:',style: TextStyle(color: const Color(0xff666666),fontSize: 14.rpx),),
                Text(' ${CommonUtils.solarToLunar(DateTime.parse(parameter['birthday']))}',style: TextStyle(fontSize: 14.rpx)),
              ],
            ):Container(),
          ],
        )
    );
  }
}
