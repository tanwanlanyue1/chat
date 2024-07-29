import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/utils/common_utils.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

import 'mine_help_controller.dart';

///我的-帮助/服务
@Deprecated("已经用网页替代")
class MineHelpPage extends StatelessWidget {
  MineHelpPage({Key? key}) : super(key: key);

  final controller = Get.put(MineHelpController());
  final state = Get
      .find<MineHelpController>()
      .state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F8FE),
      appBar: AppBar(
        centerTitle: true,
        title: Text("客服与帮助",
          style: TextStyle(color: const Color(0xff333333), fontSize: 18.rpx,),),
        backgroundColor: Colors.white,
      ),
      body: GetBuilder<MineHelpController>(
        builder: (controller) {
          return Column(
            children: [
              head(),
              Visibility(
                visible: state.helpIndex == 0,
                replacement: service(),
                child: problem(),
              ),
            ],
          );
        },
      ),
    );
  }

  //头部
  Widget head() {
    return Padding(
      padding: EdgeInsets.all(12.rpx),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: (){
                state.helpIndex = 0;
                controller.update();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.rpx),
                ),
                height: 66.rpx,
                margin: EdgeInsets.only(right: 7.rpx),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppImage.asset(
                      'assets/images/mine/complaint.png', width: 42.rpx,
                      height: 42.rpx,),
                    SizedBox(width: 12.rpx),
                    Text('常见问题', style: TextStyle(color: const Color(0xff333333),
                        fontSize: 14.rpx,
                        fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: (){
                state.helpIndex = 1;
                controller.update();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.rpx),
                ),
                height: 66.rpx,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppImage.asset('assets/images/mine/appeal.png', width: 42.rpx,
                      height: 42.rpx,),
                    SizedBox(width: 12.rpx),
                    Text('客户服务', style: TextStyle(color: const Color(0xff333333),
                        fontSize: 14.rpx,
                        fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //问题
  Widget problem() {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.all(12.rpx),
        children: [
          Row(
            children: List.generate(state.title.length, (i) =>
                GestureDetector(
                  onTap: () {
                    controller.setCurrent = i;
                    controller.disposeData('$i');
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 24.rpx),
                    child: Text("${state.title[i]}", style: TextStyle(
                        color: state.currentIndex == i
                            ? const Color(0xff333333)
                            : const Color(0xff999999), fontSize: 16.rpx,fontWeight: state.currentIndex == i ? FontWeight.bold : FontWeight.normal),),
                  ),
                )),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.rpx),
                topRight: Radius.circular(8.rpx),
              ),
            ),
            margin: EdgeInsets.only(top: 12.rpx),
            child: Column(
              children: List.generate(state.filtrateData.length, (index) => Container(
                height: 42.rpx,
                padding: EdgeInsets.all(10.rpx),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  border: Border( bottom: BorderSide(width: 1.rpx, color: const Color(0XffFAF8F7))),
                ),
                child: Text("${state.filtrateData[index]['title']}",style: TextStyle(fontSize: 14.rpx),),
              )),
            ),
          ),
        ],
      ),
    );
  }

  //客服
  Widget service(){
    return Container(
      margin: EdgeInsets.all(12.rpx),
      padding: EdgeInsets.all(12.rpx),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.rpx),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            children: [
              AppImage.asset('assets/images/mine/ls_qq.png', width: 24.rpx, height: 24.rpx),
              SizedBox(width: 8.rpx,),
              Text('QQ客服',
                  style: TextStyle(
                    fontSize: 14.rpx,
                  )),
            ],
          ),
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xffF9FAFC),
                  borderRadius: BorderRadius.circular(8.rpx),
                ),
                margin: EdgeInsets.symmetric(vertical: 12.rpx,horizontal: 40.rpx),
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 12.rpx),
                      child: GestureDetector(
                          onTap: (){
                            CommonUtils.checkBigImage('',path: 'assets/images/mine/ls_mine_qq_qrcode_big.png');
                          },
                        child:  RepaintBoundary(
                            key: controller.repaintKey,
                            child: AppImage.asset('assets/images/mine/ls_qq_service_qrcode.png', width: 60.rpx, height: 60.rpx)
                        ),
                      ),
                    ),
                    Text(
                        '点击二维码图片截屏或点击保存二维码',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12.rpx,
                            color: const Color(0xff666666)
                        )),
                    Padding(
                      padding: EdgeInsets.only(bottom: 20.rpx),
                      child: Text(
                          'QQ打开长按识别二维码添加',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12.rpx,
                              color: const Color(0xff666666)
                          )),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: (){
                      controller.saveQRCode();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xff8D310F),
                        borderRadius: BorderRadius.circular(12.rpx),
                      ),
                      width: 90.rpx,
                      height: 24.rpx,
                      alignment: Alignment.center,
                      child: Text(
                          '保存二维码',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12.rpx,
                              color: Colors.white
                          )),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
