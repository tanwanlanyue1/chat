import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

class PayDialogBlurView extends StatelessWidget {
  const PayDialogBlurView({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
        child: ClipRRect(
            borderRadius:
            BorderRadius.only(topRight: Radius.circular(24.rpx)),
            child: BackdropFilter(
                filter:
                ImageFilter.blur(sigmaX: 4.rpx, sigmaY: 4.rpx),
                child:  Container(
                      width: 124.rpx,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [
                              Color(0x64626399),
                              Color(0xFF252432)
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(24.rpx)),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          // 描边颜色
                          width: 0.65.rpx, // 描边宽度
                        ),
                      ),

                      ///用户信息
                      child: child,
                    ))));
  }
}
