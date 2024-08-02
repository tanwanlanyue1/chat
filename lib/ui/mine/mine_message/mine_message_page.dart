import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/ui/mine/mine_message/mine_message_state.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import '../../../widgets/app_image.dart';
import 'mine_message_controller.dart';

///我的-消息
class MineMessagePage extends StatelessWidget {
  MineMessagePage({Key? key}) : super(key: key);

  final controller = Get.put(MineMessageController());
  final state = Get.find<MineMessageController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.myMessage),
      ),
      body: SmartRefresher(
        controller: controller.refreshController,
        onRefresh: controller.fetchPage,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: GetBuilder<MineMessageController>(
              builder: (_){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 1.rpx),
                    ...List.generate(3, (index) {
                      // var item = state.items[index];
                      return _messageListContainer(index);
                    })
                  ].separated(
                    SizedBox(
                      height: 8.rpx,
                    ),
                  ).toList(),
                );
              })
            ),
          ],
        ),
      ),
    );
  }

  Container _messageListContainer(int index) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.rpx),
      child: GestureDetector(
        onTap: () => controller.onTapSession(index),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 10.rpx,
                  height: 10.rpx,
                  margin: EdgeInsets.only(right: 8.rpx),
                  decoration: const BoxDecoration(
                    color: AppColor.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                Text("审核成功通知",style: AppTextStyle.fs16m.copyWith(color: AppColor.gray5),),
                const Spacer(),
                Text("2024年12月12日",style: AppTextStyle.fs14m.copyWith(color: AppColor.gray9),),
              ],
            ),
            Container(
              height: 1.rpx,
              margin: EdgeInsets.only(top: 12.rpx,bottom: 16.rpx),
              color: AppColor.scaffoldBackground,
            ),
            Text("  您的提现申请已成功通过了我们的系统审核，请耐心等待到账通知!",style: AppTextStyle.fs14m.copyWith(color: AppColor.gray30),),
          ],
        ),
      ),
    );
  }
}
