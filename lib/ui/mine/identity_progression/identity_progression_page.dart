import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';

import 'identity_progression_controller.dart';

///身份进阶页
class IdentityProgressionPage extends StatelessWidget {
  IdentityProgressionPage({Key? key}) : super(key: key);

  final controller = Get.put(IdentityProgressionController());
  final state = Get.find<IdentityProgressionController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "身份进阶成功",
          style: TextStyle(
            color: const Color(0xff333333),
            fontSize: 18.rpx,
          ),
        ),
      ),
    );
  }

  //佳丽审核成功
  Widget jiaAudit(){
    return Container(
      child: Column(
        children: [
          Container(
            child: AppImage.asset('assets/images/mine/succeed.png',width: 70.rpx,height: 70.rpx,),
          ),
          Text("身份进阶成功，恭喜您成为佳丽！"),
          Text("请在下方输入框中设置您的服务费，设置成功后 点击确定按钮即可。"),
        ],
      ),
    );
  }


  //审核成功
  Widget auditSucceed(){
    return Container(
      child: Column(
        children: [
          Text("注：佳丽上线接单时就需要缴纳保证金，保证金在订单结束后将在24小时内原路退回。"),
          GestureDetector(
            onTap: null,
            child: Container(
              height: 42.rpx,
              decoration: BoxDecoration(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(8.rpx)),
              margin: EdgeInsets.symmetric(horizontal: 38.rpx, vertical: 40.rpx),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "确定",
                    style: TextStyle(color: Colors.white, fontSize: 16.rpx),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: null,
            child: Container(
              height: 42.rpx,
              decoration: BoxDecoration(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(8.rpx)),
              margin: EdgeInsets.symmetric(horizontal: 38.rpx, vertical: 40.rpx),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "确定",
                    style: TextStyle(color: Colors.white, fontSize: 16.rpx),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
