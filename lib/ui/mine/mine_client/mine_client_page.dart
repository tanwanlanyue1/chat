import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/mine/widgets/client_card.dart';

import 'mine_client_controller.dart';

//佳丽-我的客户
class MineClientPage extends StatelessWidget {
  MineClientPage({Key? key}) : super(key: key);

  final controller = Get.put(MineClientController());
  final state = Get.find<MineClientController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.myCustomer),
      ),
      backgroundColor: AppColor.scaffoldBackground,
      body: buildClient(),
    );
  }


  //客户列表
  Widget buildClient(){
    return Column(
      children: [
        SizedBox(height: 1.rpx),
        ...List.generate(5, (index) => ClientCard()),
      ],
    );
  }
}
