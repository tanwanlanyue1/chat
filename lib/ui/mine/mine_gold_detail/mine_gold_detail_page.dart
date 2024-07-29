import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:flutter_pickers/time_picker/model/date_mode.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/network/api/model/wallet/wallet_record_list.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/global.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'mine_gold_detail_controller.dart';

class MineGoldDetailPage extends StatelessWidget {
  MineGoldDetailPage({Key? key}) : super(key: key);

  final controller = Get.put(MineGoldDetailController());
  final state = Get.find<MineGoldDetailController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FE),
      appBar: AppBar(
        title: const Text("境修币明细"),
      ),
      body: Obx(() {
        return Column(
          children: [
            SizedBox(height: 1.rpx),
            Container(
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.rpx),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.onChangeTypeIndex(0),
                      behavior: HitTestBehavior.translucent,
                      child: Center(
                        child: Text(
                          "充值记录",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFF333333),
                            fontWeight: state.recordSelectType.value == 0
                                ? FontWeight.bold
                                : FontWeight.w500,
                            fontSize: state.recordSelectType.value == 0
                                ? 16.rpx
                                : 14.rpx,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const VerticalDivider(
                    thickness: 1,
                    width: 1,
                    color: Color(0xFFF6F8FE),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.onChangeTypeIndex(1),
                      behavior: HitTestBehavior.translucent,
                      child: Center(
                        child: Text(
                          "交易记录",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFF333333),
                            fontWeight: state.recordSelectType.value == 1
                                ? FontWeight.bold
                                : FontWeight.w500,
                            fontSize:
                                state.recordSelectType() == 1 ? 16.rpx : 14.rpx,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(12.rpx),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Pickers.showDatePicker(
                        context,
                        onConfirm: (val) {
                          if (val.year == null || val.month == null) return;
                          controller.selectDate(val.year!, val.month!);
                        },
                        mode: DateMode.YM,
                        pickerStyle: PickerStyle(
                          pickerTitleHeight: 65.rpx,
                          commitButton: Padding(
                            padding: EdgeInsets.only(right: 12.rpx),
                            child: Text(
                              "完成",
                              style: TextStyle(
                                  fontSize: 14.rpx,
                                  color: const Color(0xff8D310F)),
                            ),
                          ),
                          cancelButton: Padding(
                            padding: EdgeInsets.only(left: 12.rpx),
                            child: AppImage.asset(
                              "assets/images/disambiguation/close.png",
                              width: 24.rpx,
                              height: 24.rpx,
                            ),
                          ),
                          headDecoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.rpx),
                              topRight: Radius.circular(20.rpx),
                            ),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 30.rpx,
                      alignment: Alignment.center,
                      child: Wrap(
                        spacing: 1.rpx,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            state.dateString.value,
                            style: TextStyle(
                              color: const Color(0xFF333333),
                              fontSize: 12.rpx,
                            ),
                          ),
                          AppImage.asset(
                              "assets/images/mine/mine_arrow_down.png",
                              width: 16.rpx,
                              height: 12.rpx),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: state.recordSelectType.value == 1,
                    child: StadiumRadioGroup<String>(
                      items: state.dealItems,
                      selectedItem: state.dealItems[state.dealSelectType.value],
                      onChange: (_) {
                        controller.onChangeDealSelectIndex();
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SmartRefresher(
                controller: controller.pagingController.refreshController,
                onRefresh: controller.pagingController.onRefresh,
                child: PagedListView(
                  pagingController: controller.pagingController,
                  builderDelegate:
                      DefaultPagedChildBuilderDelegate<WalletRecordRes>(
                    pagingController: controller.pagingController,
                    itemBuilder: (_, item, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 12.rpx),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: index == 0
                              ? BorderRadius.vertical(top: Radius.circular(8.rpx))
                              : index == controller.pagingController.length - 1
                                  ? BorderRadius.vertical(
                                      bottom: Radius.circular(8.rpx))
                                  : null,
                        ),
                        child: Column(
                          children: [
                            Visibility(
                              visible:
                                  index == 0 && state.recordSelectType.value == 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(12.rpx),
                                    child: Text(
                                      state.amountString,
                                      maxLines: 1,
                                      style: TextStyle(
                                        color: const Color(0xFF666666),
                                        fontSize: 11.rpx,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const Divider(
                                    height: 1,
                                    color: Color(
                                      0xFFF6F8FE,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(12.rpx),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.createTime,
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: const Color(0xFF333333),
                                            fontSize: 14.rpx,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 6.rpx),
                                        Text(
                                          state.recordSelectType.value == 0
                                              ? "充值金额：￥${item.rechargeAmount}"
                                              : "类型：${item.extraPlain}",
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: const Color(0xFF666666),
                                            fontSize: 12.rpx,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 8.rpx),
                                  AppImage.asset(
                                      "assets/images/mine/mine_gold16.png",
                                      width: 16.rpx,
                                      height: 16.rpx),
                                  SizedBox(width: 4.rpx),
                                  Text(
                                    "${item.optType == 1 ? "+" : "-"}${item.amount}",
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: item.optType == 1
                                          ? const Color(0xFF8D310F)
                                          : AppColor.gray5,
                                      fontSize: 15.rpx,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible:
                                  index != controller.pagingController.length,
                              child: const Divider(
                                height: 1,
                                color: Color(0xFFF6F8FE),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
