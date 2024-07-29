
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/network/api/model/disambiguation/start_pair_model.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/disambiguation/star_sign/star_sign_state.dart';
import 'package:guanjia/widgets/app_image.dart';

///星座-匹配
class AnswerStarPair extends StatelessWidget {
  Map item;
  AnswerStarPair({super.key,required this.item});

  //配对指数
  List pairingIndex = [
    {
      "name":"两情相悦",
      "keys":"mutualAffection",
    },
    {
      "name":"天长地久",
      "keys":"lastingLove",
    },
    {
      "name":"友情",
      "keys":"friendship",
    },
    {
      "name":"爱情",
      "keys":"love",
    },
    {
      "name":"亲情",
      "keys":"familyAffinity",
    },
  ];

  final state = Get.put(StarSignState());

  String icons(String parameter){
    for (var element in state.starSignList) {
      if(element.name == parameter){
        return element.icon ?? '';
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return item['parameter'] == null?
    starPair():
    history();
  }

  //星座-配对
  Widget starPair(){
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8.rpx))
      ),
      margin: EdgeInsets.only(left: 22.rpx,right: 22.rpx),
      padding: EdgeInsets.all(12.rpx),
      child: Column(
        children: [
          Text("${item['quiz']['man'].name}男和${item['quiz']['woman'].name}女配对",style: AppTextStyle.fs16b.copyWith(color: AppColor.gray5),),
          SizedBox(height: 24.rpx,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 70.rpx,
                height: 70.rpx,
                decoration: BoxDecoration(
                  image: AppDecorations.backgroundImage(
                    "assets/images/home/pair.png",
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 4.rpx),
                      child: AppImage.asset("${item['quiz']['man'].icon}",width: 24.rpx,height: 24.rpx,),
                    ),
                    Text("男",style: AppTextStyle.fs12m.copyWith(color: AppColor.brown26),)
                  ],
                ),
              ),
              Container(
                width: 96.rpx,
                height: 62.rpx,
                decoration: BoxDecoration(
                  image: AppDecorations.backgroundImage(
                    "assets/images/home/pair_bottom.png",
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 11.rpx),
                      child: Text("${item['answer'].pairScore}%",style: AppTextStyle.fs18m.copyWith(color: AppColor.primary),),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.rpx),
                      child: Text("${item['answer'].pairDescription}",style: AppTextStyle.fs12m.copyWith(color: AppColor.primary),),
                    )
                  ],
                ),
              ),
              Container(
                width: 70.rpx,
                height: 70.rpx,
                decoration: BoxDecoration(
                  image: AppDecorations.backgroundImage(
                    "assets/images/home/pair.png",
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 4.rpx),
                      child: AppImage.asset("${item['quiz']['woman'].icon}",width: 24.rpx,height: 24.rpx,),
                    ),
                    Text("女",style: AppTextStyle.fs12m.copyWith(color: AppColor.brown26),)
                  ],
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20.rpx,top: 20.rpx),
            child: Row(
              children: [
                ...List.generate(pairingIndex.length, (index) {
                  Map pairItem = pairingIndex[index];
                  String itemKey = pairingIndex[index]['keys'];
                  return Expanded(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 20.rpx,
                              height: 130.rpx,
                              decoration: BoxDecoration(
                                  color: AppColor.gray99,
                                  borderRadius: BorderRadius.all(Radius.circular(20.rpx))
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                width: 20.rpx,
                                height: (130 * (jsonDecode(jsonEncode(item['answer']))[itemKey] / 100)).rpx,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      AppColor.brown8,
                                      AppColor.primary,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(20.rpx)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8.rpx),
                          child: Text('${jsonDecode(jsonEncode(item['answer']))[itemKey]}%',style: AppTextStyle.fs12m.copyWith(color: AppColor.gray5),),
                        ),
                        Text('${pairItem['name']}',style: AppTextStyle.fs12m.copyWith(color: AppColor.gray9),),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          Text('关系分析',style: AppTextStyle.fs16b.copyWith(color: AppColor.gray5),),
          Text('${item['answer'].relationshipAnalysis}',style: AppTextStyle.fs14m.copyWith(color: AppColor.gray30),),
          SizedBox(height: 12.rpx,),
          Text('恋爱分析',style: AppTextStyle.fs16b.copyWith(color: AppColor.gray5),),
          Text('${item['answer'].loveAnalysis}',style: AppTextStyle.fs14m.copyWith(color: AppColor.gray30),),
          SizedBox(height: 12.rpx,),
          Text('相处分析',style: AppTextStyle.fs16b.copyWith(color: AppColor.gray5),),
          Text('${item['answer'].interactionAnalysis}',style: AppTextStyle.fs14m.copyWith(color: AppColor.gray30),),
          SizedBox(height: 12.rpx,),
          Text('沟通分析',style: AppTextStyle.fs16b.copyWith(color: AppColor.gray5),),
          Text('${item['answer'].communicationAnalysis}',style: AppTextStyle.fs14m.copyWith(color: AppColor.gray30),),
        ],
      ),
    );
  }

  //历史
  Widget history(){
    StartPairModel historyData = StartPairModel.fromJson(jsonDecode(item['answer']));
    Map parameter = jsonDecode(item['parameter']);
    print("parameter==${parameter}");
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8.rpx))
      ),
      margin: EdgeInsets.only(left: 22.rpx,right: 22.rpx),
      padding: EdgeInsets.all(12.rpx),
      child: Column(
        children: [
          Text("${parameter['man']}和${parameter['woman']}配对",style: AppTextStyle.fs16b.copyWith(color: AppColor.gray5),),
          SizedBox(height: 24.rpx,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 70.rpx,
                height: 70.rpx,
                decoration: BoxDecoration(
                  image: AppDecorations.backgroundImage(
                    "assets/images/home/pair.png",
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 2.rpx),
                      child: AppImage.asset(icons(parameter['man'].substring(0, parameter['man'].length - 1)),width: 24.rpx,height: 24.rpx,),
                    ),
                    Text("男",style: AppTextStyle.fs12m.copyWith(color: AppColor.brown26),)
                  ],
                ),
              ),
              Container(
                width: 96.rpx,
                height: 62.rpx,
                decoration: BoxDecoration(
                  image: AppDecorations.backgroundImage(
                    "assets/images/home/pair_bottom.png",
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 11.rpx),
                      child: Text("${historyData.pairScore}%",style: AppTextStyle.fs18m.copyWith(color: AppColor.primary),),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.rpx),
                      child: Text("${historyData.pairDescription}",style: AppTextStyle.fs12m.copyWith(color: AppColor.primary),),
                    )
                  ],
                ),
              ),
              Container(
                width: 70.rpx,
                height: 70.rpx,
                decoration: BoxDecoration(
                  image: AppDecorations.backgroundImage(
                    "assets/images/home/pair.png",
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 2.rpx),
                      child: AppImage.asset(icons(parameter['woman'].substring(0, parameter['woman'].length - 1)),width: 24.rpx,height: 24.rpx,),
                    ),
                    Text("女",style: AppTextStyle.fs12m.copyWith(color: AppColor.brown26),)
                  ],
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20.rpx,top: 20.rpx),
            child: Row(
              children: [
                ...List.generate(pairingIndex.length, (index) {
                  Map pairItem = pairingIndex[index];
                  String itemKey = pairingIndex[index]['keys'];
                  return Expanded(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 20.rpx,
                              height: 130.rpx,
                              decoration: BoxDecoration(
                                  color: AppColor.gray99,
                                  borderRadius: BorderRadius.all(Radius.circular(20.rpx))
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                width: 20.rpx,
                                height: (130 * (jsonDecode(jsonEncode(historyData))[itemKey] / 100)).rpx,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      AppColor.brown8,
                                      AppColor.primary,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(20.rpx)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8.rpx),
                          child: Text('${jsonDecode(jsonEncode(historyData))[itemKey]}%',style: AppTextStyle.fs12m.copyWith(color: AppColor.gray5),),
                        ),
                        Text('${pairItem['name']}',style: AppTextStyle.fs12m.copyWith(color: AppColor.gray9),),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          Text('关系分析',style: AppTextStyle.fs16b.copyWith(color: AppColor.gray5),),
          Text('${historyData.relationshipAnalysis}',style: AppTextStyle.fs14m.copyWith(color: AppColor.gray30),),
          SizedBox(height: 12.rpx,),
          Text('恋爱分析',style: AppTextStyle.fs16b.copyWith(color: AppColor.gray5),),
          Text('${historyData.loveAnalysis}',style: AppTextStyle.fs14m.copyWith(color: AppColor.gray30),),
          SizedBox(height: 12.rpx,),
          Text('相处分析',style: AppTextStyle.fs16b.copyWith(color: AppColor.gray5),),
          Text('${historyData.interactionAnalysis}',style: AppTextStyle.fs14m.copyWith(color: AppColor.gray30),),
          SizedBox(height: 12.rpx,),
          Text('沟通分析',style: AppTextStyle.fs16b.copyWith(color: AppColor.gray5),),
          Text('${historyData.communicationAnalysis}',style: AppTextStyle.fs14m.copyWith(color: AppColor.gray30),),
        ],
      ),
    );
  }
}
