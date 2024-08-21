import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/input_widget.dart';
import 'package:guanjia/widgets/upload_image.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

import 'mine_feedback_controller.dart';

///意见反馈
class MineFeedbackPage extends StatelessWidget {
  MineFeedbackPage({Key? key}) : super(key: key);

  final controller = Get.put(MineFeedbackController());
  final state = Get.find<MineFeedbackController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.feedback),
      ),
      body: GetBuilder<MineFeedbackController>(
        builder: (controller) {
          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.only(bottom: 20.rpx),
                  children: [
                    feedbackType(),
                    problemOpinion(),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => controller.submit(),
                child: Container(
                  height: 50.rpx,
                  decoration: BoxDecoration(
                      color: AppColor.primary,
                      borderRadius: BorderRadius.circular(8.rpx)),
                  margin: EdgeInsets.symmetric(horizontal: 37.rpx,vertical: 8.rpx),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "提交",
                        style: TextStyle(color: Colors.white, fontSize: 16.rpx),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  //反馈类型
  Widget feedbackType() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.rpx),
      margin: EdgeInsets.only(top: 1.rpx),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 22.rpx,bottom: 16.rpx),
            child: Row(
              children: [
                Container(
                  width: 4.rpx,
                  height: 20.rpx,
                  margin: EdgeInsets.only(right: 8.rpx),
                  decoration: BoxDecoration(
                    color: AppColor.primary,
                    borderRadius: BorderRadius.circular(4.rpx),
                  ),
                ),
                Text(
                  S.current.pleaseSelectATag,
                  style: TextStyle(color: AppColor.gray30, fontSize: 16.rpx),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 100.rpx,
            child: GridView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12.rpx,
                crossAxisSpacing: 8.rpx,
                mainAxisExtent: 40.rpx
              ),
              itemCount: state.typeList.length,
              itemBuilder: (_, index) {
                var item = state.typeList[index];
                return GestureDetector(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: state.typeIndex == index ? AppColor.primary : AppColor.white8,
                      borderRadius: BorderRadius.circular(8.rpx),
                    ),
                    child: Text(
                      "${item['title']}",
                      style: TextStyle(
                          color: state.typeIndex == index ? Colors.white : AppColor.gray5,
                          fontSize: 14.rpx),
                    ),
                  ),
                  onTap: (){
                    state.typeIndex = index;
                    controller.update();
                  },
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 22.rpx,bottom: 16.rpx),
            child: Row(
              children: [
                Container(
                  width: 4.rpx,
                  height: 20.rpx,
                  margin: EdgeInsets.only(right: 8.rpx),
                  decoration: BoxDecoration(
                    color: AppColor.primary,
                    borderRadius: BorderRadius.circular(4.rpx),
                  ),
                ),
                Text(
                  S.current.specificProposalContent,
                  style: TextStyle(color: AppColor.gray30, fontSize: 16.rpx),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 16.rpx),
                color: AppColor.white8,
                child: InputWidget(
                    hintText: S.current.pleaseEnterASuggestion,
                    maxLength: 200,
                    lines: 4,
                    fillColor: AppColor.white8,
                    counterText: '',
                    inputController: controller.contentController,
                    onChanged: (val){
                      controller.update();
                    },
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.rpx,vertical: 16.rpx),
                ),
              ),
              Positioned(
                bottom: 16.rpx,
                right: 16.rpx,
                child: Text(
                  "${controller.contentController.text.length}/200",
                  style: TextStyle(color: const Color(0xff666666), fontSize: 14.rpx),
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 24.rpx,bottom: 16.rpx),
            child: Row(
              children: [
                Container(
                  width: 4.rpx,
                  height: 20.rpx,
                  margin: EdgeInsets.only(right: 8.rpx),
                  decoration: BoxDecoration(
                    color: AppColor.primary,
                    borderRadius: BorderRadius.circular(4.rpx),
                  ),
                ),
                Text(
                  S.current.uploadPictures,
                  style: TextStyle(color: AppColor.gray30, fontSize: 16.rpx),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.rpx),
            ),
            padding: EdgeInsets.only(bottom: 24.rpx),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 12.rpx),
                  child: UploadImage(
                    imgList: state.imgList,
                    callback: (val) {
                      state.imgList = val;
                      controller.update();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //联系方式
  Widget problemOpinion() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 8.rpx),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            margin: EdgeInsets.only(top: 8.rpx),
            padding: EdgeInsets.symmetric(horizontal: 16.rpx),
            child: Row(
              children: [
                Container(
                  height: 50.rpx,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(right: 12.rpx),
                  child: Text(
                    S.current.contactNumber,
                    style: TextStyle(color: AppColor.gray30, fontSize: 16.rpx),
                  ),
                ),
                Expanded(
                  child: InputWidget(
                      hintText: '',
                      fillColor: Colors.white,
                      inputController: controller.contactController,
                      textStyle: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(8.rpx))),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
