
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/disambiguation/star_sign/star_sign_state.dart';
import 'package:guanjia/widgets/app_image.dart';

import '../../../common/network/api/model/talk_model.dart';

///星座-回答
class AnswerStarSign extends StatelessWidget {
  Map item;
  AnswerStarSign({super.key,required this.item});

  //运势
  List fortune = [
    {
      "name":"综合运势",
      "keys":"overview",
    },
    {
      "name":"爱情运势",
      "keys":"love",
    },
    {
      "name":"事业运势",
      "keys":"career",
    },
    {
      "name":"财运运势",
      "keys":"money",
    },
    {
      "name":"健康运势",
      "keys":"health",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return item['parameter'] == null?
    starSign():
    history();
  }

  //星座-运势
  Widget starSign(){
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8.rpx))
      ),
      margin: EdgeInsets.only(left: 22.rpx,right: 22.rpx),
      padding: EdgeInsets.all(12.rpx),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 60.rpx,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8.rpx))
                ),
                margin: EdgeInsets.only(right: 11.rpx),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${item['quiz']['constellation'].name}",style: AppTextStyle.fs20m.copyWith(color: AppColor.red1),),
                    Text("${item['quiz']['constellation'].name}${item['quiz']['time']}运势",style: AppTextStyle.fs14m.copyWith(color: AppColor.red1),),
                  ],
                ),
              ),
              AppImage.asset(
                "assets/images/home/rectangle.png",
                width: 90.rpx,
                height: 90.rpx,
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10.rpx),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 4.rpx),
                  child: Text('综合运势：',style: AppTextStyle.fs14b.copyWith(color: AppColor.gray5),),
                ),
                Stack(
                  children: [
                    Container(
                      width: 130.rpx,
                      height: 12.rpx,
                      decoration: BoxDecoration(
                          color: AppColor.gray99,
                          borderRadius: BorderRadius.all(Radius.circular(20.rpx))
                      ),
                    ),
                    Container(
                      width: (130 * double.parse(item['answer'].overviewPercent.replaceAll('%', '')) / 100).rpx,
                      height: 12.rpx,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            AppColor.brown8,
                            AppColor.primary,
                          ],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20.rpx)),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.rpx),
                  child: Text('${item['answer'].overviewPercent}',style: AppTextStyle.fs12m.copyWith(color: AppColor.primary),),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 10.rpx,right: 6.rpx),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 4.rpx),
                      child: Text('财富运势：',style: AppTextStyle.fs12b.copyWith(color: AppColor.gray5),),
                    ),
                    Stack(
                      children: [
                        Container(
                          width: 60.rpx,
                          height: 8.rpx,
                          decoration: BoxDecoration(
                              color: AppColor.gray99,
                              borderRadius: BorderRadius.all(Radius.circular(20.rpx))
                          ),
                        ),
                        Container(
                          width: (60 * double.parse(item['answer'].moneyPercent.replaceAll('%', '')) / 100).rpx,
                          height: 8.rpx,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                AppColor.brown8,
                                AppColor.primary,
                              ],
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20.rpx)),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 6.rpx),
                      child: Text('${item['answer'].moneyPercent}',style: AppTextStyle.fs10m.copyWith(color: AppColor.primary),),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10.rpx),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 4.rpx),
                      child: Text('爱情运势：',style: AppTextStyle.fs12b.copyWith(color: AppColor.gray5),),
                    ),
                    Stack(
                      children: [
                        Container(
                          width: 60.rpx,
                          height: 8.rpx,
                          decoration: BoxDecoration(
                              color: AppColor.gray99,
                              borderRadius: BorderRadius.all(Radius.circular(20.rpx))
                          ),
                        ),
                        Container(
                          width: (60 * double.parse(item['answer'].lovePercent.replaceAll('%', '')) / 100).rpx,
                          height: 8.rpx,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                AppColor.brown8,
                                AppColor.primary,
                              ],
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20.rpx)),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.rpx),
                      child: Text('${item['answer'].lovePercent}',style: AppTextStyle.fs10m.copyWith(color: AppColor.primary),),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 10.rpx,right: 6.rpx),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 4.rpx),
                      child: Text('健康运势：',style: AppTextStyle.fs12b.copyWith(color: AppColor.gray5),),
                    ),
                    Stack(
                      children: [
                        Container(
                          width: 60.rpx,
                          height: 8.rpx,
                          decoration: BoxDecoration(
                              color: AppColor.gray99,
                              borderRadius: BorderRadius.all(Radius.circular(20.rpx))
                          ),
                        ),
                        Container(
                          width: (60 * double.parse(item['answer'].healthPercent.replaceAll('%', '')) / 100).rpx,
                          height: 8.rpx,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                AppColor.brown8,
                                AppColor.primary,
                              ],
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20.rpx)),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 6.rpx),
                      child: Text('${item['answer'].healthPercent}',style: AppTextStyle.fs10m.copyWith(color: AppColor.primary),),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10.rpx),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 4.rpx),
                      child: Text('事业运势：',style: AppTextStyle.fs12b.copyWith(color: AppColor.gray5),),
                    ),
                    Stack(
                      children: [
                        Container(
                          width: 60.rpx,
                          height: 8.rpx,
                          decoration: BoxDecoration(
                              color: AppColor.gray99,
                              borderRadius: BorderRadius.all(Radius.circular(20.rpx))
                          ),
                        ),
                        Container(
                          width: (60 * double.parse(item['answer'].careerPercent.replaceAll('%', '')) / 100).rpx,
                          height: 8.rpx,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                AppColor.brown8,
                                AppColor.primary,
                              ],
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20.rpx)),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 6.rpx),
                      child: Text('${item['answer'].careerPercent}',style: AppTextStyle.fs10m.copyWith(color: AppColor.primary),),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 80.rpx,
                height: 80.rpx,
                decoration: BoxDecoration(
                  image: AppDecorations.backgroundImage(
                    "assets/images/home/answer_star.png",
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 42.rpx,
                      height: 42.rpx,
                      decoration: BoxDecoration(
                          color: AppColor.brown27,
                          borderRadius: BorderRadius.all(Radius.circular(42.rpx))
                      ),
                      child: Center(
                        child: Text("${item['answer'].luckyColor}",style: AppTextStyle.fs14b.copyWith(color: AppColor.brown26),),
                      ),
                    ),
                    Text("幸运颜色",style: AppTextStyle.fs12m.copyWith(color: AppColor.brown26),)
                  ],
                ),
              ),
              Container(
                width: 80.rpx,
                height: 80.rpx,
                decoration: BoxDecoration(
                  image: AppDecorations.backgroundImage(
                    "assets/images/home/answer_star.png",
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 42.rpx,
                      height: 42.rpx,
                      decoration: BoxDecoration(
                          color: AppColor.brown27,
                          borderRadius: BorderRadius.all(Radius.circular(42.rpx))
                      ),
                      child: Center(
                        child: Text("${item['answer'].luckyNumber}",style: AppTextStyle.fs14b.copyWith(color: AppColor.brown26),),
                      ),
                    ),
                    Text("幸运数字",style: AppTextStyle.fs12m.copyWith(color: AppColor.brown26),)
                  ],
                ),
              ),
              Container(
                width: 80.rpx,
                height: 80.rpx,
                decoration: BoxDecoration(
                  image: AppDecorations.backgroundImage(
                    "assets/images/home/answer_star.png",
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 42.rpx,
                      height: 42.rpx,
                      decoration: BoxDecoration(
                          color: AppColor.brown27,
                          borderRadius: BorderRadius.all(Radius.circular(42.rpx))
                      ),
                      child: Center(
                        child: Text("${(item['answer'].speedMatchConstellation).substring(0,2)}",style: AppTextStyle.fs14b.copyWith(color: AppColor.brown26),),
                      ),
                    ),
                    Text("速配星座",style: AppTextStyle.fs12m.copyWith(color: AppColor.brown26),)
                  ],
                ),
              ),
            ],
          ),
          Column(
            children: List.generate(fortune.length, (index) {
              String itemKey = fortune[index]['keys'];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 150.rpx,
                    height: 40.rpx,
                    decoration: BoxDecoration(
                      image: AppDecorations.backgroundImage(
                        "assets/images/home/star_underframe.png",
                      ),
                    ),
                    margin: EdgeInsets.only(top: 20.rpx,bottom: 12.rpx),
                    child: Center(
                      child: Text("${fortune[index]['name']}",style: AppTextStyle.fs16m.copyWith(color: AppColor.gray5),),
                    ),
                  ),
                  Text("${jsonDecode(jsonEncode(item['answer']))[itemKey]}",style: AppTextStyle.fs14m.copyWith(color: AppColor.gray30),)
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  //历史
  Widget history(){
    StarFortuneModel historyData = StarFortuneModel.fromJson(jsonDecode(item['answer']));
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8.rpx))
      ),
      margin: EdgeInsets.only(left: 22.rpx,right: 22.rpx),
      padding: EdgeInsets.all(12.rpx),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 60.rpx,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8.rpx))
                ),
                margin: EdgeInsets.only(right: 11.rpx),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${jsonDecode(item['parameter'])['constellationStr']}",style: AppTextStyle.fs20m.copyWith(color: AppColor.red1),),
                    Text("${jsonDecode(item['parameter'])['constellationStr']}${jsonDecode(item['parameter'])['timeTypeStr']}运势",style: AppTextStyle.fs14m.copyWith(color: AppColor.red1),),
                  ],
                ),
              ),
              AppImage.asset(
                "assets/images/home/rectangle.png",
                width: 90.rpx,
                height: 90.rpx,
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10.rpx),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 4.rpx),
                  child: Text('综合运势：',style: AppTextStyle.fs14b.copyWith(color: AppColor.gray5),),
                ),
                Stack(
                  children: [
                    Container(
                      width: 130.rpx,
                      height: 12.rpx,
                      decoration: BoxDecoration(
                          color: AppColor.gray99,
                          borderRadius: BorderRadius.all(Radius.circular(20.rpx))
                      ),
                    ),
                    Container(
                      width: (130 * double.parse(historyData.overviewPercent!.replaceAll('%', '')) / 100).rpx,
                      height: 12.rpx,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            AppColor.brown8,
                            AppColor.primary,
                          ],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20.rpx)),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.rpx),
                  child: Text('${historyData.overviewPercent}',style: AppTextStyle.fs12m.copyWith(color: AppColor.primary),),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 10.rpx,right: 6.rpx),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 4.rpx),
                      child: Text('财富运势：',style: AppTextStyle.fs12b.copyWith(color: AppColor.gray5),),
                    ),
                    Stack(
                      children: [
                        Container(
                          width: 60.rpx,
                          height: 12.rpx,
                          decoration: BoxDecoration(
                              color: AppColor.gray99,
                              borderRadius: BorderRadius.all(Radius.circular(20.rpx))
                          ),
                        ),
                        Container(
                          width: (60 * double.parse(historyData.moneyPercent!.replaceAll('%', '')) / 100).rpx,
                          height: 12.rpx,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                AppColor.brown8,
                                AppColor.primary,
                              ],
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20.rpx)),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 6.rpx),
                      child: Text('${historyData.moneyPercent}',style: AppTextStyle.fs10m.copyWith(color: AppColor.primary),),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10.rpx),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 4.rpx),
                      child: Text('爱情运势：',style: AppTextStyle.fs12b.copyWith(color: AppColor.gray5),),
                    ),
                    Stack(
                      children: [
                        Container(
                          width: 60.rpx,
                          height: 12.rpx,
                          decoration: BoxDecoration(
                              color: AppColor.gray99,
                              borderRadius: BorderRadius.all(Radius.circular(20.rpx))
                          ),
                        ),
                        Container(
                          width: (60 * double.parse(historyData.lovePercent!.replaceAll('%', '')) / 100).rpx,
                          height: 12.rpx,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                AppColor.brown8,
                                AppColor.primary,
                              ],
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20.rpx)),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.rpx),
                      child: Text('${historyData.lovePercent}',style: AppTextStyle.fs10m.copyWith(color: AppColor.primary),),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 10.rpx,right: 6.rpx),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 4.rpx),
                      child: Text('健康运势：',style: AppTextStyle.fs12b.copyWith(color: AppColor.gray5),),
                    ),
                    Stack(
                      children: [
                        Container(
                          width: 60.rpx,
                          height: 12.rpx,
                          decoration: BoxDecoration(
                              color: AppColor.gray99,
                              borderRadius: BorderRadius.all(Radius.circular(20.rpx))
                          ),
                        ),
                        Container(
                          width: (60 * double.parse(historyData.healthPercent!.replaceAll('%', '')) / 100).rpx,
                          height: 12.rpx,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                AppColor.brown8,
                                AppColor.primary,
                              ],
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20.rpx)),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 6.rpx),
                      child: Text('${historyData.healthPercent}',style: AppTextStyle.fs10m.copyWith(color: AppColor.primary),),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10.rpx),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 4.rpx),
                      child: Text('事业运势：',style: AppTextStyle.fs12b.copyWith(color: AppColor.gray5),),
                    ),
                    Stack(
                      children: [
                        Container(
                          width: 60.rpx,
                          height: 12.rpx,
                          decoration: BoxDecoration(
                              color: AppColor.gray99,
                              borderRadius: BorderRadius.all(Radius.circular(20.rpx))
                          ),
                        ),
                        Container(
                          width: (60 * double.parse(historyData.careerPercent!.replaceAll('%', '')) / 100).rpx,
                          height: 12.rpx,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                AppColor.brown8,
                                AppColor.primary,
                              ],
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20.rpx)),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.rpx),
                      child: Text('${historyData.careerPercent}',style: AppTextStyle.fs10m.copyWith(color: AppColor.primary),),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 80.rpx,
                height: 80.rpx,
                decoration: BoxDecoration(
                  image: AppDecorations.backgroundImage(
                    "assets/images/home/answer_star.png",
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 42.rpx,
                      height: 42.rpx,
                      decoration: BoxDecoration(
                          color: AppColor.brown27,
                          borderRadius: BorderRadius.all(Radius.circular(42.rpx))
                      ),
                      child: Center(
                        child: Text("${historyData.luckyColor}",style: AppTextStyle.fs14b.copyWith(color: AppColor.brown26),),
                      ),
                    ),
                    Text("幸运颜色",style: AppTextStyle.fs12m.copyWith(color: AppColor.brown26),)
                  ],
                ),
              ),
              Container(
                width: 80.rpx,
                height: 80.rpx,
                decoration: BoxDecoration(
                  image: AppDecorations.backgroundImage(
                    "assets/images/home/answer_star.png",
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 42.rpx,
                      height: 42.rpx,
                      decoration: BoxDecoration(
                          color: AppColor.brown27,
                          borderRadius: BorderRadius.all(Radius.circular(42.rpx))
                      ),
                      child: Center(
                        child: Text("${historyData.luckyNumber}",style: AppTextStyle.fs14b.copyWith(color: AppColor.brown26),),
                      ),
                    ),
                    Text("幸运数字",style: AppTextStyle.fs12m.copyWith(color: AppColor.brown26),)
                  ],
                ),
              ),
              Container(
                width: 80.rpx,
                height: 80.rpx,
                decoration: BoxDecoration(
                  image: AppDecorations.backgroundImage(
                    "assets/images/home/answer_star.png",
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 42.rpx,
                      height: 42.rpx,
                      decoration: BoxDecoration(
                          color: AppColor.brown27,
                          borderRadius: BorderRadius.all(Radius.circular(42.rpx))
                      ),
                      child: Center(
                        child: Text((historyData.speedMatchConstellation)!.substring(0,2),style: AppTextStyle.fs14b.copyWith(color: AppColor.brown26),),
                      ),
                    ),
                    Text("速配星座",style: AppTextStyle.fs12m.copyWith(color: AppColor.brown26),)
                  ],
                ),
              ),
            ],
          ),
          Column(
            children: List.generate(fortune.length, (index) {
              String itemKey = fortune[index]['keys'];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 150.rpx,
                    height: 40.rpx,
                    decoration: BoxDecoration(
                      image: AppDecorations.backgroundImage(
                        "assets/images/home/star_underframe.png",
                      ),
                    ),
                    margin: EdgeInsets.only(top: 20.rpx,bottom: 12.rpx),
                    child: Center(
                      child: Text("${fortune[index]['name']}",style: AppTextStyle.fs16m.copyWith(color: AppColor.gray5),),
                    ),
                  ),
                  Text("${jsonDecode(jsonEncode(historyData))[itemKey]}",style: AppTextStyle.fs14m.copyWith(color: AppColor.gray30),)
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
