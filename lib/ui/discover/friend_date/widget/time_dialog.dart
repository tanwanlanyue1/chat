import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/common_utils.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/common_gradient_button.dart';

import 'scroll_index_page.dart';

//征友约会-选择时间
class TimeDialog extends StatelessWidget {
  TimeDialog({super.key});

  static Future<bool?> show() {
    return Get.dialog(
      TimeDialog(),
    );
  }

  List<String> timeList = [];
  int current = 0;
  List<String> getNextSevenDays() {
    List<String> list = [];
    DateTime today = DateTime.now();
    for (int i = 0; i < 7; i++) {
      DateTime nextDay = today.add(Duration(days: i));
      list.add(CommonUtils.dateString('$nextDay',lineFeed: true));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    timeList = getNextSevenDays();
    return GestureDetector(
      onTap: (){
        Get.back();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            width: 331.rpx,
            height: 380.rpx,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8.rpx)),
            ),
            padding: EdgeInsets.all(16.rpx),
            // margin: EdgeInsets.symmetric(horizontal: ),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  child: AppImage.asset('assets/images/common/close.png',width: 24.rpx,height: 24.rpx,),
                ),
                SizedBox(height: 8.rpx),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 12.rpx,
                      crossAxisSpacing: 12.rpx,
                      mainAxisExtent: 60.rpx
                  ),
                  itemCount: timeList.length,
                  itemBuilder: (_, index) {
                    return GestureDetector(
                      onTap: (){},
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: current == index ? AppColor.primary : AppColor.scaffoldBackground,
                          borderRadius: BorderRadius.circular(8.rpx),
                        ),
                        child: Text(
                          timeList[index],
                          style: TextStyle(
                              color: current == index ? Colors.white : AppColor.gray5,
                              fontWeight: current == index ? FontWeight.bold : FontWeight.normal,
                              fontSize: 14.rpx,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 24.rpx,bottom: 17.rpx),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("时间选择",style: AppTextStyle.fs14m.copyWith(color: AppColor.gray9),),
                      Text("7:00",style: AppTextStyle.fs16b.copyWith(color: AppColor.gray5),),
                    ],
                  ),
                ),
                ScrollIndexPage(
                  currentSelectIndex: 5,
                ),
                const Spacer(),
                CommonGradientButton(
                  height: 50.rpx,
                  text: S.current.confirm,
                  onTap: (){
                    print("123");
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
