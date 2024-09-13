// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:guanjia/common/app_color.dart';
// import 'package:guanjia/common/app_text_style.dart';
// import 'package:guanjia/common/extension/get_extension.dart';
// import 'package:guanjia/common/utils/screen_adapt.dart';
// import 'package:guanjia/global.dart';
// import 'package:guanjia/widgets/app_image.dart';
// import 'package:guanjia/widgets/widgets.dart';
//
// class WelcomePage extends StatelessWidget {
//   const WelcomePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       extendBody: true,
//       body: Stack(
//         alignment: Alignment.center,
//         fit: StackFit.expand,
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AppAssetImage('assets/images/home/launch_image.png'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//             alignment: const Alignment(0, 84/140-1),
//             child: AppImage.asset(
//               'assets/images/home/launch_image_1.png',
//               width: 276.rpx,
//               height: 554.rpx,
//             ),
//           ),
//           Container(
//             width: Get.width,
//             height: Get.height,
//             padding:
//                 FEdgeInsets(bottom: max(48.rpx, Get.mediaQuery.padding.bottom)),
//             alignment: Alignment.bottomCenter,
//             child: Button(
//               onPressed: () {
//                 Global.agreePrivacyPolicy()
//                     .whenComplete(Get.navigateToHomeOrLogin);
//               },
//               backgroundColor: Colors.white,
//               borderRadius: BorderRadius.circular(8.rpx),
//               width: 300.rpx,
//               height: 50.rpx,
//               child: Text(
//                 '立即体验',
//                 style: AppTextStyle.fs16m.copyWith(color: AppColor.black3),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
