import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

import 'rectify_the_workplace_controller.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

///整顿职场
class RectifyTheWorkplaceView extends StatelessWidget {
  RectifyTheWorkplaceView({super.key});

  final controller = Get.put(RectifyTheWorkplaceController());
  final state = Get.find<RectifyTheWorkplaceController>().state;
  late double screenWidth;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return ListView(
      children: [
        buildTopic(),
        hotTopic(),
        topicClassify(),
        waterFallList(),
      ],
    );
  }

  ///话题类型
  Widget buildTopic(){
    return Container(
      padding: EdgeInsets.only(left: 4.rpx,right: 4.rpx),
      margin: EdgeInsets.only(top: 12.rpx,bottom: 12.rpx),
      // child: Row(
      //   children: List.generate(state.topicType.length, (i) => Expanded(
      //     child: GestureDetector(
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           Container(
      //             width: 40.rpx,
      //             height: 40.rpx,
      //             color: Colors.black12,
      //             margin: EdgeInsets.only(bottom: 4.rpx),
      //           ),
      //           Text("${state.topicType[i].name}",
      //             style: TextStyle(fontSize: 14.rpx,fontWeight: FontWeight.bold),),
      //         ],
      //       ),
      //       onTap: (){},
      //     ),
      //   )),
      // ),
    );
  }
  ///热门话题
  Widget hotTopic(){
    return Container(
      padding: EdgeInsets.only(left: 8.rpx,right: 4.rpx,bottom: 12.rpx,top: 12.rpx),
      margin: EdgeInsets.symmetric(horizontal: 4.rpx),
      decoration: BoxDecoration(
        border: Border.all(width: 0,color: Colors.grey),
        borderRadius: BorderRadius.all(Radius.circular(6.rpx))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10.rpx),
            child: Text("// 热门话题",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.rpx),),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 4.rpx,
              mainAxisExtent: 28.rpx
              // childAspectRatio: 24 / 10,
            ),
            itemCount: state.hotTopic.length,
            itemBuilder: (_, index) {
              var item = state.hotTopic[index];
              return GestureDetector(
                child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text("#${item['name']}#",style: const TextStyle(),)),
                onTap: (){},
              );
            },
          ),
        ],
      ),
    );
  }
  ///话题分类
  Widget topicClassify(){
    return ObxValue((dataRx) => Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 12.rpx,top: 12.rpx,bottom: 5.rpx),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1.rpx,color: const Color(0X99A1A6B3))),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(state.topicClassify.length, (i) {
            return GestureDetector(
              child: Container(
                margin: EdgeInsets.only(right: 12.rpx),
                child: Text("${state.topicClassify[i]}",style: TextStyle(fontSize: 16.rpx,color: dataRx.value == i ? Colors.black : Colors.grey,fontWeight: FontWeight.w500),),
              ),
              onTap: (){
                dataRx.value = i;
              },
            );
          }),
        ),
      ),
    ), state.classifyIndex);
  }

  Widget waterFallList(){
    return MasonryGridView.count(
      crossAxisCount: 2,
      itemCount: state.fallsList.length,
      itemBuilder: (BuildContext context, int index) {
        var item = state.fallsList[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppImage.network(
              item['icon'],
              width: double.parse(item['width']).rpx,
              height: ((screenWidth/2-8.rpx)/double.parse(item['width']).rpx)*double.parse(item['height']).rpx,
            ),
            SizedBox(height: 4.rpx,),
            Text("${item['title']}",style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: 4.rpx,),
            Row(
              children: [
                AppImage.network(
                  item['header'],
                  width: 16.rpx,
                  height: 16.rpx,
                  shape: BoxShape.circle,
                ),
                Container(
                  margin: EdgeInsets.only(left: 12.rpx),
                  child: Text("${item['userName']}"),
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(4.rpx),
                  ),
                  width: 36.rpx,
                  child: Center(child: Text("阅读",style: TextStyle(color: Colors.white),)),
                ),
                Text(' ${item['read']}'),
              ],
            ),
          ],
        );
      },
      mainAxisSpacing: 16.rpx,
      crossAxisSpacing: 8.rpx,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap:true,
    );
  }
}
