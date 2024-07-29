import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/ui/disambiguation/widgets/disambiguation_radio.dart';
import 'package:guanjia/ui/disambiguation/widgets/disambiguation_row_item.dart';
import 'package:guanjia/ui/mine/mine_record/record_details/record_details_state.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/input_widget.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/lunar/lunar_view.dart';
import 'record_details_controller.dart';

///文档详情页
class RecordDetailsPage extends GetView<RecordDetailsController> {
  RecordDetailsPage({Key? key, this.archivesInfo}) : super(key: key);

  final ArchivesInfo? archivesInfo; //档案id

  RecordDetailsState get state => Get.find<RecordDetailsController>().state;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecordDetailsController>(
      init: RecordDetailsController(info: archivesInfo),
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text(controller.isAdd ? "新建档案" : "编辑档案"),
          ),
          body: buildBody(context),
        );
      },
    );
  }

  Widget buildBody(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.rpx).copyWith(
        top: 12.rpx,
      ),
      color: Colors.white,
      child: ListView(
        padding: EdgeInsets.only(
          top: 20.rpx,
          left: 12.rpx,
          right: 12.rpx,
        ),
        children: [
          GestureDetector(
            onTap: controller.selectCamera,
            child: AppImage.network(
              controller.info?.avatar ?? "",
              width: 80.rpx,
              height: 80.rpx,
              shape: BoxShape.circle,
              placeholder: AppImage.asset(
                "assets/images/mine/mine_head_default.png",
              ),
            ),
          ),
          DisambiguationRowItem(
            title: "性别",
            padding: true,
            decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 0.5.rpx,
                      color: const Color.fromRGBO(141, 49, 15, 0.06))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DisambiguationRadio(
                  isSelect: controller.info?.sex != 1,
                  title: "男",
                  titleFalse: "女",
                  left: 64,
                  selectColor: const Color(0xff684326),
                  unselectColor: const Color(0xff999999),
                  titleCall: (bool? val) {
                    controller.onSelectSex(val ?? true);
                  },
                ),
              ],
            ),
          ),
          DisambiguationRowItem(
            title: "昵称",
            padding: true,
            height: 48.rpx,
            decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 0.5.rpx,
                      color: const Color.fromRGBO(141, 49, 15, 0.06))),
            ),
            child: InputWidget(
              hintText: '请填写昵称',
              textAlign: TextAlign.right,
              inputController: controller.nickController,
              fillColor: Colors.transparent,
              onChanged: (content) {
                controller.onChangeNick(content);
              },
            ),
          ),
          // DisambiguationRowItem(
          //   title: "标签",
          //   padding: true,
          //   height: 30.rpx,
          //   decoration: BoxDecoration(
          //     border: Border(
          //         bottom: BorderSide(
          //             width: 0.5.rpx,
          //             color: const Color.fromRGBO(141, 49, 15, 0.06))),
          //   ),
          //   child: InputWidget(
          //       hintText: '请填写标签',
          //       right: true,
          //       fillColor: Colors.transparent,
          //       onChanged: (val) {
          //         print("val===$val");
          //       }),
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: List.generate(
          //       state.labelList.length,
          //       (index) => Text(
          //             "#${state.labelList[index]['name']}#",
          //             style: TextStyle(
          //                 color: const Color(0xffEEC88A), fontSize: 12.rpx),
          //           )),
          // ),
          DisambiguationRowItem(
            padding: true,
            title: "出生时间",
            height: 48.rpx,
            decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 0.5.rpx,
                      color: const Color.fromRGBO(141, 49, 15, 0.06))),
            ),
            child: GestureDetector(
              onTap: () {
                LunarView.show(
                  onSelectionChanged: (List<String> value) {
                    controller.onSelectBirthDate(value);
                  },
                );
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    controller.info?.birth ?? "",
                    style: TextStyle(fontSize: 14.rpx),
                  ),
                  AppImage.asset(
                    "assets/images/mine/right.png",
                    width: 20.rpx,
                    height: 20.rpx,
                  ),
                ],
              ),
            ),
          ),
          // DisambiguationRowItem(
          //   height: 48.rpx,
          //   padding: true,
          //   title: "出生地点",
          //   decoration: BoxDecoration(
          //     border: Border(
          //         bottom: BorderSide(
          //             width: 0.5.rpx,
          //             color: const Color.fromRGBO(141, 49, 15, 0.06))),
          //   ),
          //   child: GestureDetector(
          //     onTap: () {
          //       Pickers.showAddressPicker(
          //         context,
          //         initProvince: "${state.allAddressBirth['province']}",
          //         initCity: "${state.allAddressBirth['city']}",
          //         initTown: "${state.allAddressBirth['town']}",
          //         addAllItem: false,
          //         onConfirm: (p, c, t) {
          //           state.allAddressBirth['addressOfBirth'] = "$p$c$t";
          //           state.allAddressBirth['province'] = p;
          //           state.allAddressBirth['city'] = c;
          //           state.allAddressBirth['town'] = "$t";
          //           // controller.refreshData();
          //         },
          //       );
          //     },
          //     behavior: HitTestBehavior.opaque,
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.end,
          //       children: [
          //         Text(
          //           "${state.allAddressBirth['addressOfBirth']}",
          //           style: TextStyle(fontSize: 14.rpx),
          //         ),
          //         AppImage.asset(
          //           "assets/images/mine/right.png",
          //           width: 20.rpx,
          //           height: 20.rpx,
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          DisambiguationRowItem(
            title: "现居地",
            height: 48.rpx,
            padding: true,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 0.5.rpx,
                  color: const Color.fromRGBO(141, 49, 15, 0.06),
                ),
              ),
            ),
            child: GestureDetector(
              onTap: () {
                Pickers.showAddressPicker(
                  context,
                  addAllItem: false,
                  onConfirm: (p, c, t) {
                    controller.onSelectAddress(p, c, t ?? "");
                  },
                );
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    controller.info?.currentResidence ?? "",
                    style: TextStyle(fontSize: 14.rpx),
                  ),
                  AppImage.asset(
                    "assets/images/mine/right.png",
                    width: 20.rpx,
                    height: 20.rpx,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 110.rpx),
          GestureDetector(
            onTap: controller.onTapCommit,
            child: Container(
              width: 140.rpx,
              height: 36.rpx,
              alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: 60.rpx),
              decoration: BoxDecoration(
                color: const Color(0xff8D310F),
                borderRadius: BorderRadius.circular(20.rpx),
              ),
              child: Text(
                controller.isAdd ? "完成添加" : "保存",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.rpx,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
