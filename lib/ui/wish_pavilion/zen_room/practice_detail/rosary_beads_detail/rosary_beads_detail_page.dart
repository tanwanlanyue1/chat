import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/date_time_extension.dart';
import 'package:guanjia/common/extension/string_extension.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/network/api/model/wish_pavilion/rosary_beads_record_model.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/widgets.dart';

import 'rosary_beads_detail_controller.dart';

class RosaryBeadsDetailPage extends StatelessWidget {
  RosaryBeadsDetailPage({Key? key}) : super(key: key);

  final controller = Get.put(RosaryBeadsDetailController());
  final state = Get.find<RosaryBeadsDetailController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("念珠"),
      ),
      body: PagedListView.separated(
        padding: EdgeInsets.only(top: 12.rpx),
        pagingController: controller.pagingController,
        builderDelegate: DefaultPagedChildBuilderDelegate<RosaryBeadsRecordModel>(
          pagingController: controller.pagingController,
          itemBuilder: (_, item, index){
            final textStyle = AppTextStyle.st.medium.size(14.rpx);
            return Container(
              height: 66.rpx,
              padding: FEdgeInsets(horizontal: 12.rpx),
              alignment: Alignment.center,
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          style: textStyle.textColor(AppColor.gray5),
                          TextSpan(
                            text: "开始时间：",
                            children: [
                              TextSpan(
                                text: item.startTime.dateTime?.formatHHmmss,
                                style: textStyle.textColor(AppColor.gray9),
                              ),
                            ],
                          ),
                        ),
                        Spacing.h4,
                        Text.rich(
                          style: textStyle.textColor(AppColor.gray5),
                          TextSpan(
                            text: "结束时间：",
                            children: [
                              TextSpan(
                                text: item.endTime.dateTime?.formatHHmmss,
                                style: textStyle.textColor(AppColor.gray9),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.rpx),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "本次念珠",
                        style: textStyle.size(12.rpx).textColor(AppColor.gray9),
                      ),
                      Text(
                        item.count.toString(),
                        style: textStyle.bold
                            .size(18.rpx)
                            .textColor(const Color(0xFF8D310F)),
                      ),
                    ],
                  ),
                  SizedBox(width: 8.rpx),
                ],
              ),
            );
          }
        ),
        separatorBuilder: (_, __) => SizedBox(height: 1.rpx),
      ),
    );
  }
}
