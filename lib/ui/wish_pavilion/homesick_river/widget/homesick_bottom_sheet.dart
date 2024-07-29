import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/wish_pavilion/homesick_river/homesick_river_controller.dart';
import 'package:guanjia/widgets/app_image.dart';

import '../../../../common/network/api/model/talk_model.dart';

///思亲河-弹窗
class HomesickBottomSheet {
  ///sky：是否河灯
  ///self：是否自己
  ///benediction：祝福回调
  static void show({
    required RecordDetailsModel item,
    bool sky = false,
    bool self = false,
    Function()? benediction,
    Function()? callback,
  }) {
    Get.bottomSheet(
      GetBuilder<HomesickRiverController>(
        id: "homeShow",
        builder: (controller) {
          return Container(
            decoration: BoxDecoration(
              color: const Color(0xffF6F8FE),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.rpx),
                topRight: Radius.circular(20.rpx),
              ),
            ),
            padding: EdgeInsets.only(bottom: 8.rpx),
            height: sky ? 526.rpx : 420.rpx,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.rpx),
                        topRight: Radius.circular(20.rpx),
                      ),
                    ),
                    padding: EdgeInsets.only(left: 50.rpx),
                    height: 50.rpx,
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              sky ? "思念河灯" : "许愿天灯",
                              style: TextStyle(
                                  fontSize: 18.rpx,
                                  color: const Color(0xff8D310F)),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            width: 50.rpx,
                            height: 50.rpx,
                            color: Colors.transparent,
                            child: const Icon(
                              Icons.close,
                              color: Color(0xff684326),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        Visibility(
                            visible: item.gift?.type == 3,
                            child: Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.rpx),
                                ),
                                width: 100.rpx,
                                height: 100.rpx,
                                margin: EdgeInsets.only(top: 8.rpx),
                                child: Center(
                                  child: Container(
                                    height: 92.rpx,
                                    width: 92.rpx,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1.5.rpx,
                                            color: AppColor.gold7),
                                        borderRadius:
                                            BorderRadius.circular(8.rpx)),
                                    child: AppImage.network(
                                      "${item.gift?.image}",
                                      width: 90.rpx,
                                      height: 90.rpx,
                                    ),
                                  ),
                                ),
                              ),
                            )),
                        Row(
                          children: [
                            Visibility(
                              visible: !sky,
                              child: AppImage.network(
                                item.gift!.image,
                                width: 60.rpx,
                                height: 90.rpx,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: const Color(0xffFFF1D5),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(8.rpx))),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 12.rpx, vertical: 8.rpx),
                                padding: EdgeInsets.only(
                                    top: 4.rpx,
                                    left: 12.rpx,
                                    right: 12.rpx,
                                    bottom: 8.rpx),
                                child: RichText(
                                  text: TextSpan(
                                    text: "${item.gift!.name}\n",
                                    style: TextStyle(
                                        color: const Color(0xff8D310F),
                                        fontSize: 16.rpx,
                                        fontWeight: FontWeight.bold,
                                        height: 2),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: item.gift!.remark,
                                        style: TextStyle(
                                            color: const Color(0xff8D310F),
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14.rpx,
                                            height: 1.4),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                  bottom: 8.rpx,
                                  right: 4.rpx,
                                  left: 8.rpx,
                                  top: 4.rpx),
                              margin: EdgeInsets.symmetric(horizontal: 12.rpx),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    width: 1.rpx,
                                    color: const Color(0xffE6E6E6)),
                                borderRadius: BorderRadius.circular(8.rpx),
                              ),
                              height: 120.rpx,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Visibility(
                                    visible: item.gift?.type == 4,
                                    replacement: Text(
                                      (item.open == 0 || (item.uid == SS.login.info?.uid)) ?
                                      (item.open == 1 ? '(本内容仅发布者自身可见) \n${item.desire}' : ' ${item.desire}') :
                                      '(本内容仅发布者自身可见)',
                                      style: AppTextStyle.fs14m
                                          .copyWith(color: AppColor.gray9),
                                    ),
                                    child: Text(
                                      (item.open == 0 || (item.uid == SS.login.info?.uid)) ?
                                      (item.open == 1 ? '(本内容仅发布者自身可见) \n我虔诚祈求，愿${item.name}${item.desire}' : ' 我虔诚祈求，愿${item.name}${item.desire}') :
                                      '(本内容仅发布者自身可见)',
                                      style: AppTextStyle.fs14m
                                          .copyWith(color: AppColor.gray9),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text("${item.userName}",
                                        style: AppTextStyle.fs14m
                                            .copyWith(color: AppColor.gray30)),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              right: 87.rpx,
                              bottom: 10.rpx,
                              child: Visibility(
                                visible: item.status == 2 ||
                                    (item.gift?.type == 4 && item.status == 1),
                                child: Visibility(
                                  visible: item.status == 2,
                                  replacement: AppImage.asset(
                                    "assets/images/wish_pavilion/homesick/fulfill_wish.png",
                                    width: 74.rpx,
                                    height: 57.rpx,
                                  ),
                                  child: AppImage.asset(
                                    "assets/images/wish_pavilion/homesick/finish.png",
                                    width: 74.rpx,
                                    height: 57.rpx,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: 12.rpx, right: 8.rpx, top: 20.rpx),
                          height: 40.rpx,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  SS.login.requiredAuthorized(() {
                                    item.isBless = 1;
                                    item.bless = item.bless! + 1;
                                    item.blessList
                                        ?.add(SS.login.info?.avatar);
                                    controller
                                        .recordBlessing(id: item.id!)
                                        .then((value) => {
                                      if (value == true)
                                        {benediction?.call()}
                                    });
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1.5.rpx,
                                          color: const Color(0xffC41717)),
                                      borderRadius:
                                      BorderRadius.circular(20.rpx)),
                                  height: 40.rpx,
                                  padding:
                                  EdgeInsets.symmetric(horizontal: 16.rpx),
                                  margin: EdgeInsets.only(right: 16.rpx),
                                  child: Row(
                                    children: [
                                      AppImage.asset(
                                        (item.isBless == 1)
                                            ? "assets/images/wish_pavilion/homesick/benediction_select.png"
                                            : "assets/images/wish_pavilion/homesick/benediction.png",
                                        width: 24.rpx,
                                        height: 24.rpx,
                                      ),
                                      Text(
                                        " 已收到${item.bless}人祝福",
                                        style: TextStyle(
                                            color: const Color(0xffC41717),
                                            fontSize: 16.rpx),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Wrap(
                                  spacing: -6.rpx,
                                  children: List.generate(
                                      item.blessList?.length ?? 0, (index) {
                                    return AppImage.network(
                                      "${item.blessList?[index]}",
                                      width: 30.rpx,
                                      height: 30.rpx,
                                      shape: BoxShape.circle,
                                    );
                                  }),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: self && item.status != 2,
                    child: Center(
                      child: Visibility(
                        visible: item.gift?.type == 4 && item.status == 1,
                        replacement: GestureDetector(
                          onTap: () {
                            if (item.status == 0) {
                              item.status = 1;
                            } else {
                              item.status = 0;
                            }
                            controller.update(['homeShow']);
                            callback?.call();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColor.red1,
                              borderRadius: BorderRadius.circular(50.rpx),
                            ),
                            width: 200.rpx,
                            height: 46.rpx,
                            margin: EdgeInsets.only(top: 10.rpx),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${status(sky, item.status!)}',
                                  style: AppTextStyle.fs16b
                                      .copyWith(color: Colors.white),
                                ),
                                Text(
                                  "功德+${item.gift?.mavNum} 修行值+${item.gift?.cavNum}",
                                  style: AppTextStyle.fs12m
                                      .copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Get.back();
                            controller.wishAgain(item);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1.5.rpx, color: AppColor.red1),
                              borderRadius: BorderRadius.circular(50.rpx),
                            ),
                            width: 200.rpx,
                            height: 46.rpx,
                            margin: EdgeInsets.only(top: 10.rpx),
                            alignment: Alignment.center,
                            child: Text(
                              "再次许愿",
                              style: AppTextStyle.fs16m
                                  .copyWith(color: AppColor.red1),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }

  //状态
  //type 3:河灯 4：天灯 status（河灯 0:可收起 1:可重新放灯 2:已结束）（天灯 0:可完愿 1：已完愿）
  static String? status(bool sky, int status) {
    if (sky) {
      switch (status) {
        case 0:
          return '收起';
        case 1:
          return '重新放灯';
        case 2:
          return '';
      }
    } else {
      switch (status) {
        case 0:
          return '完愿';
        case 1:
          return '';
      }
    }
  }
}
