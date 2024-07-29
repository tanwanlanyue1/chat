import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/home/widget/home_drawer_controller.dart';
import 'package:guanjia/ui/plaza/fortune_square/fortune_square_view.dart';
import 'package:guanjia/widgets/app_image.dart';

import 'plaza_controller.dart';
///广场
class PlazaPage extends StatefulWidget {
  const PlazaPage({super.key});

  @override
  State<PlazaPage> createState() => _PlazaPageState();
}

class _PlazaPageState extends State<PlazaPage> with AutomaticKeepAliveClientMixin {

  final controller = Get.put(PlazaController());
  final state = Get.find<PlazaController>().state;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColor.brown32,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: Text("运势广场",style: AppTextStyle.fs18b.copyWith(color: AppColor.gray5),),
        centerTitle: false,
        actions: [
          GestureDetector(
            onTap: HomeDrawerController.open,
            child: Container(
              margin: EdgeInsets.only(right: 16.rpx),
              child: AppImage.asset(
                "assets/images/plaza/conversation.png",
                width: 24.rpx,
                height: 24.rpx,
              ),
            )
          ),
       ],
      ),
      body: FortuneSquareView(),
    );
  }

  @override
  bool get wantKeepAlive => true;

}
