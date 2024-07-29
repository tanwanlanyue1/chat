import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/ui/plaza/plaza_controller.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

class ShowBottomSheet extends StatelessWidget {
  ShowBottomSheet({super.key});

  static final state = Get.find<PlazaController>().state;

  static void show() {
    Get.bottomSheet(
      Container(
        height: 160.rpx,
        padding: EdgeInsets.symmetric(horizontal: 12.rpx),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.rpx),
            topRight: Radius.circular(20.rpx),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 20.rpx,bottom: 12.rpx),
              child: Text("内容反馈",style: TextStyle(fontSize: 16.rpx),),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(state.feedback.length, (i) => GestureDetector(
                onTap: (){
                  contentFeedback(i);
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.rpx,color: const Color(0xffCDCDCD)),
                      borderRadius: BorderRadius.circular(10.rpx)
                  ),
                  padding: EdgeInsets.symmetric(vertical: 8.rpx,horizontal: 12.rpx),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 8.rpx),
                        child: AppImage.asset(state.feedback[i]['icon'],width: 20.rpx,height: 20.rpx,),
                      ),
                      Text("${state.feedback[i]['name']}",style: TextStyle(fontSize: 14.rpx,color: const Color(0xff999999))),
                    ],
                  ),
                ),
              )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: Container(
                    width: 300.rpx,
                    margin: EdgeInsets.only(top: 20.rpx),
                    padding: EdgeInsets.only(left: 12.rpx, right: 12.rpx),
                    height: 40.rpx,
                    color: Colors.transparent,
                    child: Text('取消', style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.rpx,
                        height: 1.5.rpx),textAlign: TextAlign.center,),
                  ),
                  onTap: () {
                    Get.back(result: "返回参数");
                  },
                )
              ],
            ),
          ],
        ),
      )
    );
  }

  ///举报类型
  static void reportType() {
    Get.bottomSheet(
        Container(
          height: 280.rpx,
          padding: EdgeInsets.symmetric(horizontal: 12.rpx),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.rpx),
              topRight: Radius.circular(20.rpx),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 20.rpx,bottom: 20.rpx),
                child: Text("请选择你想要举报的类型",style: TextStyle(fontSize: 16.rpx,color: const Color(0xff999999)),),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20.rpx),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10.rpx,
                      crossAxisSpacing: 10.rpx,
                      mainAxisExtent: 36.rpx
                  ),
                  itemCount: state.reportTypeList.length,
                  itemBuilder: (_, index) {
                    return GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                            color: const Color(0xffF6F7F9),
                            borderRadius: BorderRadius.all(Radius.circular(10.rpx))
                        ),
                        alignment: Alignment.center,
                        child: Text(state.reportTypeList[index],
                          style: TextStyle(fontSize: 14.rpx),),
                      ),
                      onTap: (){
                        Get.back();
                      },
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    child: Container(
                      width: 300.rpx,
                      padding: EdgeInsets.only(left: 12.rpx, right: 12.rpx),
                      // height: 30.rpx,
                      color: Colors.transparent,
                      child: Text('取消', style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.rpx,
                          height: 1.5.rpx),textAlign: TextAlign.center,),
                    ),
                    onTap: () {
                      Get.back();
                    },
                  )
                ],
              ),
            ],
          ),
        )
    );
  }


  static void contentFeedback(int type){
    switch (type) {
      case 0:
        Get.back();
        return reportType();
      case 1:
        return print("object");
      case 2:
        return reportType();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
