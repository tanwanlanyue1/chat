import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety_flutter3/flutter_swiper_null_safety_flutter3.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/extension/string_extension.dart';
import 'package:guanjia/common/utils/app_link.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';

import '../common/network/api/api.dart';

//广告轮播
class AdvertisingSwiper extends StatefulWidget {
  int position;
  EdgeInsets? insets;

  AdvertisingSwiper({super.key, required this.position, this.insets});

  @override
  State<AdvertisingSwiper> createState() => _AdvertisingSwiperState();
}

class _AdvertisingSwiperState extends State<AdvertisingSwiper> {
  List<AdvertisingStartupModel> swiperImg = [];

  /// 获取广告轮播
  void startupAdvertList() async {
    final response =
        await OpenApi.startupAdvertList(type: 2, position: widget.position);
    if (response.isSuccess) {
      swiperImg = response.data ?? [];
      setState(() {});
    }
  }

  //广告跳转
  onTapAdvertising(int i) {
    final item = swiperImg[i];
    final url = item.gotoUrl;
    if(url != null){
      AppLink.jump(
        url,
        title: item.title,
        args: item.gotoParam?.toJson(),
      );
    }
  }

  @override
  void initState() {
    startupAdvertList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return swiperImg.isNotEmpty
        ? Container(
            height: 80.rpx,
            margin: widget.insets ?? EdgeInsets.all(12.rpx),
            child: Swiper(
              autoplay: true,
              loop: false,
              itemBuilder: (BuildContext context, int index) {
                return AppImage.network(
                  swiperImg[index].image ?? '',
                  align: Alignment.topCenter,
                  borderRadius: BorderRadius.circular(8.rpx),
                  width: Get.width - 24.rpx,
                  height: 80.rpx,
                );
              },
              itemCount: swiperImg.length,
              indicatorLayout: PageIndicatorLayout.DROP,
              onTap: (i) => onTapAdvertising(i),
            ),
          )
        : Container();
  }
}
