import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/ui/mine/widgets/archives_card.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

///档案弹出
class ArchivesBottomSheet {
  static void show({Function()? callback}) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 12.rpx, vertical: 24.rpx),
        decoration: BoxDecoration(
          color: const Color(0xffF5F1E9),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.rpx),
            topRight: Radius.circular(20.rpx),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: (){
                    Get.back();
                  },
                  child: const Icon(Icons.close,color: Color(0xff684326),),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "选择档案",
                      style: TextStyle(fontSize: 18.rpx,color: const Color(0xff684326)),
                    ),
                  ),
                ),
                GestureDetector(
                  child: Text(
                    "编辑",
                    style: TextStyle(fontSize: 14.rpx,color: const Color(0xff684326)),
                  ),
                  onTap: (){
                    Get.toNamed(AppRoutes.mineRecordPage);
                  },
                ),
              ],
            ),
            Expanded(
              child: ListView(
              padding: EdgeInsets.only(top: 16.rpx),
              children: List.generate(8, (index) => ArchivesCard(
                data: ArchivesInfo(),
                callback: (){},
              ))
              ),
            ),
          ],
        ),
      ),
    );
  }

}
