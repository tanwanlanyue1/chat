import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/widgets/app_image.dart';
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
      backgroundColor: const Color(0xffF6F8FE),
      appBar: AppBar(
        title: const Text("意见反馈"),
      ),
      body: GetBuilder<MineFeedbackController>(
        builder: (controller) {
          return Padding(
            padding: EdgeInsets.only(
                left: 12.rpx, right: 12.rpx, top: 10.rpx, bottom: 20.rpx),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.only(bottom: 20.rpx),
                    children: [
                      explain(),
                      feedbackType(),
                      problemOpinion(),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => controller.submit(),
                  child: Container(
                    height: 42.rpx,
                    decoration: BoxDecoration(
                        color: const Color(0xff8D310F),
                        borderRadius: BorderRadius.circular(23.rpx)),
                    margin: EdgeInsets.symmetric(horizontal: 8.rpx),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "提交",
                          style:
                              TextStyle(color: Colors.white, fontSize: 16.rpx),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  //解释
  Widget explain() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.rpx),
      ),
      padding: EdgeInsets.all(12.rpx),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "给我们留言",
            style: TextStyle(
              color: const Color(0xff333333),
              fontSize: 16.rpx,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "如果你对我们平台有任何疑问或者意见、建议，你可以在此窗口给我们留言，我们将尽快给你回复!!!",
            style: TextStyle(
                color: const Color(0xff999999),
                fontSize: 14.rpx,
                height: 1.5.rpx),
          ),
        ],
      ),
    );
  }

  //反馈类型
  Widget feedbackType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12.rpx, bottom: 10.rpx, top: 20.rpx),
          child: Text(
            '请选择反馈类型',
            style: TextStyle(color: const Color(0xff666666), fontSize: 14.rpx),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.rpx),
          ),
          padding: EdgeInsets.all(12.rpx),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
                state.typeList.length,
                (i) => GestureDetector(
                      onTap: () {
                        state.typeIndex = i;
                        controller.update();
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 8.rpx),
                        child: Row(
                          children: [
                            AppImage.asset(
                              state.typeIndex == i
                                  ? 'assets/images/mine/selected.png'
                                  : 'assets/images/mine/unselected.png',
                              width: 20.rpx,
                              height: 20.rpx,
                            ),
                            Text(
                              "  ${state.typeList[i]['title']}",
                              style: TextStyle(
                                  color: const Color(0xff333333),
                                  fontSize: 14.rpx),
                            ),
                          ],
                        ),
                      ),
                    )),
          ),
        ),
      ],
    );
  }

  //问题与意见
  Widget problemOpinion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12.rpx, bottom: 10.rpx, top: 20.rpx),
          child: RichText(
            text: TextSpan(
              text: '* ',
              style: TextStyle(
                color: const Color(0xffE23A29),
                fontSize: 14.rpx,
              ),
              children: [
                TextSpan(
                  text: '问题与意见',
                  style: TextStyle(
                    color: const Color(0xff666666),
                    fontSize: 14.rpx,
                  ),
                ),
              ],
            ),
          ),
        ),
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.rpx),
              ),
              padding: EdgeInsets.only(bottom: 24.rpx),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12.rpx),
                  InputWidget(
                      hintText: '请输入申诉描述，描述越详细申诉越容易成功',
                      maxLength: 500,
                      lines: 4,
                      fillColor: Colors.white,
                      counterText: '',
                      // focusNode: controller.focusNode,
                      inputController: controller.contentController,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12.rpx),
                      onChanged: (val) {
                        controller.update();
                      }),
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
            Positioned(
              bottom: 6.rpx,
              right: 8.rpx,
              child: Text(
                "${controller.contentController.text.length}/500",
                style:
                    TextStyle(color: const Color(0xff666666), fontSize: 12.rpx),
              ),
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: 12.rpx, bottom: 10.rpx, top: 20.rpx),
          child: Text(
            '联系方式',
            style: TextStyle(color: const Color(0xff666666), fontSize: 14.rpx),
          ),
        ),
        InputWidget(
            hintText: '请填写您的手机号码或邮箱，便于与您联系(选填)',
            fillColor: Colors.white,
            // focusNode: controller.focusNode,
            inputController: controller.contactController,
            border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(8.rpx))),
            onChanged: (val) {
              // controller.setController = val;
            }),
      ],
    );
  }
}
