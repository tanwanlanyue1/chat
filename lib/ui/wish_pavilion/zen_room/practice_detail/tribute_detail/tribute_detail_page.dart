import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/functions_extension.dart';
import 'package:guanjia/common/extension/string_extension.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/network/api/model/wish_pavilion/offering_record_model.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/widigets/zen_room_gift_countdown.dart';
import 'package:guanjia/widgets/app_image.dart';

import 'tribute_detail_controller.dart';

class TributeDetailPage extends StatelessWidget {
  TributeDetailPage({Key? key}) : super(key: key);

  final controller = Get.put(TributeDetailController());
  final state = Get.find<TributeDetailController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("供品顶礼"),
      ),
      body: PagedListView.separated(
        padding: EdgeInsets.only(top: 12.rpx),
        pagingController: controller.pagingController,
        builderDelegate: DefaultPagedChildBuilderDelegate<OfferingRecordModel>(
            pagingController: controller.pagingController,
            itemBuilder: (_, item, index) {
              final textStyle = AppTextStyle.st.medium.size(14.rpx);
              return Container(
                padding: EdgeInsets.all(12.rpx),
                color: Colors.white,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.rpx),
                      child: Container(
                        width: 100.rpx,
                        height: 120.rpx,
                        color: const Color(0x268D310F),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Positioned(
                              top: 8.rpx,
                              bottom: 8.rpx,
                              child: AppImage.network(
                                item.buddhaImage,
                                width: 70.rpx,
                                height: 105.rpx,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Container(
                              height: 24.rpx,
                              color: const Color(0xB38D310F),
                              alignment: Alignment.center,
                              child: Text(
                                item.buddhaName,
                                style: AppTextStyle.st.medium
                                    .size(12.rpx)
                                    .textColor(Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 16.rpx),
                    Expanded(
                        child: Column(
                      children: item.recordList.map((element) {
                        final endTime = element.endTime.dateTime;
                        return Row(
                          children: [
                            Expanded(
                                flex: 2,
                                child: Text(
                                  element.giftName,
                                  style: textStyle.textColor(AppColor.gray5),
                                )),
                            Expanded(
                              flex: 2,
                              child: Text.rich(
                                style: textStyle.textColor(AppColor.gray9),
                                TextSpan(
                                  text: "供养 ",
                                  children: [
                                    TextSpan(
                                        text: element.count.toString(),
                                        style: AppTextStyle.st.bold
                                            .size(18.rpx)
                                            .textColor(
                                                const Color(0xFF8D310F))),
                                    const TextSpan(text: "次"),
                                  ],
                                ),
                              ),
                            ),
                            // if (endTime != null)
                              Expanded(
                                flex: 3,
                                child: ZenRoomGiftCountdown(
                                  endTime: endTime ?? DateTime.now(),
                                  textAlign: TextAlign.right,
                                  textStyle:
                                      textStyle.textColor(AppColor.gray9),
                                ),
                              ),
                          ],
                        );
                      }).toList(),
                    )),
                  ],
                ),
              );
            }),
        separatorBuilder: (_, __) => SizedBox(height: 1.rpx),
      ),
    );
  }
}
