import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/ui/home/bottom_sheet_chat/bottom_sheet_chat_page.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/input_widget.dart';
import 'package:guanjia/widgets/down_input.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

import 'default_controller.dart';

///默认视图
class DefaultView extends StatelessWidget {
  DefaultView({Key? key}) : super(key: key);

  final controller = Get.put(DefaultController());
  final state = Get.find<DefaultController>().state;

  @override
  Widget build(BuildContext context) {
    return acquiesceBody();
  }

  ///默认
  Widget acquiesceBody(){
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(12.rpx),
          child: Row(
            children: [
              AppImage.asset(
                "assets/images/disambiguation/issue.png",
                width: 24.rpx,
                height: 24.rpx,
              ),
              Text(" 别人的疑惑",style: AppTextStyle.fs18b.copyWith(color: AppColor.brown26),),
              const Spacer(),
              InkWell(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.rpx,color: const Color(0xff8D310F)),
                      borderRadius: BorderRadius.circular(8.rpx)
                  ),
                  height: 24.rpx,
                  width: 56.rpx,
                  alignment: Alignment.center,
                  child: Text('换一批',style: TextStyle(color: const Color(0xff8D310F),fontSize: 12.rpx),),
                ),
                onTap: (){},
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 12.rpx,right: 12.rpx),
            padding: EdgeInsets.only(left: 12.rpx,right: 12.rpx),
            decoration: BoxDecoration(
              color: const Color(0xffEBE7DF),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.rpx),
                topRight: Radius.circular(8.rpx),
              ),
            ),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 9.rpx,
                crossAxisSpacing: 15.rpx,
                mainAxisExtent: 51.rpx,
              ),
              padding: EdgeInsets.symmetric(vertical: 12.rpx),
              itemCount: state.disambiguationList.length,
              itemBuilder: (_, i) {
                var item = state.disambiguationList[i];
                return GestureDetector(
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: const Color(0xffF5F1E9),
                            border: Border.all(width: 1.rpx,color: const Color(0xffCDCDCD)),
                            borderRadius: BorderRadius.circular(20.rpx)
                        ),
                        height: 40.rpx,
                        width: 156.rpx,
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 11.rpx),
                        child: Text(item['name'],style: TextStyle(fontSize: 14.rpx,color: const Color(0xff684326)),textAlign: TextAlign.center,maxLines: 1,overflow: TextOverflow.ellipsis,),
                      ),
                      Visibility(
                        visible: item['hot'] ?? false,
                        child: Positioned(
                          top: 0,
                          right: 0,
                          child: AppImage.asset(
                            "assets/images/disambiguation/group.png",
                            width: 20.rpx,
                            height: 20.rpx,
                          ),
                        ),
                      )
                    ],
                  ),
                  onTap: (){},
                );
              },
            ),
          ),
        ),
        buildBottom(),
      ],
    );
  }

  ///底部聊天
  Widget buildBottom(){
    return Container(
      height: 40.rpx,
      margin: EdgeInsets.symmetric(vertical: 10.rpx),
      padding: EdgeInsets.symmetric(horizontal: 12.rpx),
      child: Row(
        children: [
          SizedBox(
            width: 60.rpx,
            child: DownInput(
              value: '3.5',
              currentData: {"name":"3.5"},
              data: [{"name":"3.5"},{"name":"4.0"}],
              defaultBackgroundColor: Colors.transparent,
              defaultTextColor: const Color(0xff8D310F),
              defaultIconColor: const Color(0xff8D310F),
              callback: (val){},
            ),
          ),
          Expanded(
            child: InputWidget(
                hintText: '想跟我聊什么',
                fillColor: const Color(0xffFFFFFF),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.rpx),
                    bottomLeft: Radius.circular(8.rpx),
                  ),
                ),
                onChanged: (val) {
                  controller.chatController.text = val;
                }
            ),
          ),
          GestureDetector(
            onTap: (){
              BottomSheetChatPage.show(type: 0);
            },
            child: Container(
                padding: EdgeInsets.only(left: 4.rpx,right: 8.rpx),
                width: 100.rpx,
                height: 40.rpx,
                decoration: BoxDecoration(
                  color: Colors.white,
                  image: AppDecorations.backgroundImage("assets/images/disambiguation/rectangle.png"),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(8.rpx),
                    topRight: Radius.circular(8.rpx),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 4.rpx),
                      decoration: BoxDecoration(
                        image: AppDecorations.backgroundImage(
                          'assets/images/disambiguation/gold.png'
                        )
                      ),
                      width: 28.rpx,
                      height: 28.rpx,
                      alignment: Alignment.center,
                      child: Text("3",style: TextStyle(fontSize: 20.rpx,color: Colors.white)),
                    ),
                    Text(' 境修币',style: AppTextStyle.fs14m.copyWith(color: Colors.white,height: 1.8),),
                  ],
                )
            ),
          ),
        ],
      ),
    );
  }
}
