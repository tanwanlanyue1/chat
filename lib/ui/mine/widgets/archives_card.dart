import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

class ArchivesCard extends StatelessWidget {
  final ArchivesInfo data; //档案项
  final Color? itemColor; //档案项背景色
  final bool archives; //档案列表
  final Function()? callback; //回调
  const ArchivesCard(
      {super.key,
      required this.data,
      this.archives = false,
      this.itemColor,
      this.callback});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
            color: itemColor ?? const Color(0xffEBE7DF),
            border: Border.all(
                color: archives ? Colors.transparent : Color(0xffCDCDCD)),
            borderRadius: BorderRadius.all(Radius.circular(8.rpx))),
        margin: EdgeInsets.only(bottom: 8.rpx),
        padding: EdgeInsets.only(left: 12.rpx, right: 16.rpx),
        height: 70.rpx,
        child: Row(
          children: [
            AppImage.network(
              data.avatar ?? "",
              width: 40.rpx,
              height: 40.rpx,
              shape: BoxShape.circle,
            ),
            SizedBox(width: 8.rpx),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          data.nickname ?? "",
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 14.rpx,
                            color: const Color(0xff684326),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 4.rpx, right: 4.rpx),
                        child: AppImage.asset(
                          data.sex == 0
                              ? "assets/images/disambiguation/man.png"
                              : "assets/images/disambiguation/girl.png",
                          width: 16.rpx,
                          height: 16.rpx,
                        ),
                      ),
                      // Visibility(
                      //   visible: archives,
                      //   child: Text(
                      //     "自己",
                      //     style: TextStyle(
                      //         fontSize: 14.rpx, color: Color(0xff2E9959)),
                      //   ),
                      // ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5.rpx),
                    child: Text(
                      data.birth ?? "",
                      style: TextStyle(
                        fontSize: 12.rpx,
                        color: const Color(0xff684326),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: archives,
              replacement: Text(
                "客户",
                style: TextStyle(fontSize: 14.rpx, color: Color(0xff2E9959)),
              ),
              child: Text(
                "编辑",
                style: TextStyle(fontSize: 14.rpx, color: Color(0xff999999)),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        callback?.call();
      },
    );
  }
}
