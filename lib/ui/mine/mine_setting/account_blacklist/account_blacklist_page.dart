import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

import 'account_blacklist_controller.dart';

///用户黑名单
class AccountBlacklistPage extends StatelessWidget {
  AccountBlacklistPage({Key? key}) : super(key: key);

  final controller = Get.put(AccountBlacklistController());
  final state = Get.find<AccountBlacklistController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F8FE),
      appBar: AppBar(
        centerTitle: true,
        title: Text("黑名单管理",style: TextStyle(color: const Color(0xff333333),fontSize: 18.rpx,),),
        backgroundColor: Colors.white,
      ),
      body: ObxValue((blackList) => ListView.builder(
        padding: EdgeInsets.all(12.rpx),
        itemBuilder: (BuildContext context, int index) {
          return blacklistItem(state.blackList[index],index: index);
        },
        itemCount: blackList.length,
      ), state.blackList),
    );
  }

  ///黑名单项
  Widget blacklistItem(Map item,{required int index}){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: index == 0 ?
        BorderRadius.only(
          topLeft: Radius.circular(8.rpx),
          topRight: Radius.circular(8.rpx),
        ):BorderRadius.zero,
      ),
      height: 56.rpx,
      margin: EdgeInsets.only(bottom: 1.rpx),
      padding: EdgeInsets.all(12.rpx),
      child: Row(
        children: [
          AppImage.network(
            item['image'],
            width: 32.rpx,
            height: 32.rpx,
            shape: BoxShape.circle,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8.rpx),
            child: Text('${item['name']}',style: TextStyle(fontSize: 12.rpx,color: const Color(0xff333333)),),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xffEEC88A),
              borderRadius: BorderRadius.circular(2.rpx),
            ),
            width: 28.rpx,
            height: 14.rpx,
            alignment: Alignment.center,
            child: Text("Lv ${item['grade']}",style: TextStyle(color: Colors.white,fontSize: 10.rpx),),
          ),
          const Spacer(),
          GestureDetector(
            onTap: (){
              state.blackList.removeAt(index);
            },
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xff333333),
                borderRadius: BorderRadius.circular(4.rpx),
              ),
              width: 70.rpx,
              height: 24.rpx,
              alignment: Alignment.center,
              child: Text("移除黑名单",style: TextStyle(color: Colors.white,fontSize: 12.rpx),),
            ),
          ),
        ],
      ),
    );
  }

}
