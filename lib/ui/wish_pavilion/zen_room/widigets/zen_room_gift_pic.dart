import 'dart:async';

import 'package:flutter/material.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/zen_room_state.dart';
import 'package:guanjia/widgets/app_image.dart';

///供品图片+动效
class ZenRoomGiftPic extends StatelessWidget {
  final ZenRoomGiftModel item;
  final double width;
  final double height;

  const ZenRoomGiftPic({super.key, required this.item, required this.width,required this.height});

  @override
  Widget build(BuildContext context) {
    final svgaIcon = item.svga.trim();
    if (svgaIcon.startsWith('http')) {
      return AppImage.networkSvga(svgaIcon, repeat: false);
    }
    return AppImage.network(
      item.image,
      width: width,
      height: height,
      align: Alignment.bottomCenter,
    );
  }
}
