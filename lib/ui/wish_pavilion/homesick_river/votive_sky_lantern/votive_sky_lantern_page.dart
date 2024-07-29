import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';

import 'votive_sky_lantern_controller.dart';

///许愿天灯
class VotiveSkyLanternPage extends StatelessWidget {
  VotiveSkyLanternPage({Key? key}) : super(key: key);

  final controller = Get.put(VotiveSkyLanternController());
  final state = Get.find<VotiveSkyLanternController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('许愿天灯',style: TextStyle(color: const Color(0xff333333),fontSize: 18.rpx),),
      ),
      backgroundColor: const Color(0xffF6F8FE),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          skyClassify(),
          buildSkyLantern(),
        ],
      ),
    );
  }

  ///天灯类型
  Widget skyClassify(){
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 12.rpx,top: 12.rpx),
      margin: EdgeInsets.only(bottom: 1.rpx),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.rpx),
          topRight: Radius.circular(8.rpx),
        ),
      ),
      child: TabBar(
        controller: controller.tabController,
        labelColor: const Color(0xff8D310F),
        labelStyle: TextStyle(fontSize: 16.rpx,fontWeight: FontWeight.bold),
        unselectedLabelColor: const Color(0xff666666),
        unselectedLabelStyle: TextStyle(fontSize: 16.rpx),
        indicatorColor: const Color(0xff8D310F),
        indicatorSize: TabBarIndicatorSize.label,
        indicatorWeight: 4.rpx,
        indicatorPadding: EdgeInsets.only(bottom: 4.rpx),
        labelPadding: EdgeInsets.only(bottom: 8.rpx,right: 12.rpx),
        onTap: (index){
          controller.disposeData(state.skyLanternType[index]['type']);
        },
        tabs: state.skyLanternType.map((item) {
          return Text("${item['title']}");
        }).toList()
      ),
    );
  }

  ///天灯
  Widget buildSkyLantern(){
    return GetBuilder<VotiveSkyLanternController>(
      builder: (_){
        return Padding(
          padding: EdgeInsets.only(top: 14.rpx,left: 10.rpx),
          child: Wrap(
            spacing: 20.rpx,
            runSpacing: 18.rpx,
            children: List.generate(state.filtrateData.length, (i) {
              var item = state.filtrateData[i];
              return GestureDetector(
                onTap: (){
                  controller.getConfig(item);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.rpx),
                  ),
                  width: 100.rpx,
                  height: 140.rpx,
                  padding: EdgeInsets.symmetric(
                      vertical: 5.rpx, horizontal: 6.rpx),
                  child: Container(
                    width: 92.rpx,
                    height: 132.rpx,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1.5.rpx,color: const Color(0xffFFF1D5)),
                        borderRadius: BorderRadius.circular(8.rpx)
                    ),
                    child: Column(
                      children: [
                        AppImage.network(item.image,width: 60.rpx,height: 90.rpx,fit: BoxFit.contain,),
                        Container(
                          decoration: BoxDecoration(
                              color: const Color(0xffFFF1D5),
                              borderRadius: BorderRadius.circular(4.rpx)
                          ),
                          width: 80.rpx,
                          height: 30.rpx,
                          alignment: Alignment.center,
                          child: Text(item.name,style: TextStyle(color: const Color(0xff8D310F),fontSize: 14.rpx),),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
