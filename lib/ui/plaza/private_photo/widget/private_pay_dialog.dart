import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

import '../../../../common/service/service.dart';
import '../../../../widgets/app_image.dart';
import '../../../../widgets/user_avatar.dart';
import '../../../chat/widgets/chat_avatar.dart';

class PrivatePayDialog  extends StatelessWidget {


  const PrivatePayDialog._({super.key,});

  ///- true 确认发起， false取消
  static Future<bool> show() async{
    final ret = await Get.dialog<bool>(
      PrivatePayDialog._(
      ),
    );
    return ret == true;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 311.rpx,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8.rpx)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: Get.back,
                icon: AppImage.asset(
                  'assets/images/common/close.png',
                  width: 24.rpx,
                  height: 24.rpx,
                ),
              ),
            ),
            Row(
              children: [
                Container( width: 24.rpx,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 10.rpx,),
                          Text(
                            '小明',
                            style: TextStyle(
                              fontSize: 16.rpx,
                              fontWeight: FontWeight.w600,
                            )
                          )
                        ]
                      )
                    ]
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
