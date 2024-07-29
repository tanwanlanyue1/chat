import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

import '../../../../../common/network/api/api.dart';

class MessageSystemItem extends StatelessWidget {
  const MessageSystemItem({
    super.key,
    required this.item,
  });

  final MessageList item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.rpx),
      padding: EdgeInsets.all(12.rpx),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8.rpx)),
      ),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '【系统消息】${item.systemMessage?.title ?? ''}',
            style: TextStyle(
              color: const Color(0xFF333333),
              fontWeight: FontWeight.w500,
              fontSize: 14.rpx,
            ),
          ),
          SizedBox(height: 5.rpx),
          Text(
            item.systemMessage?.content ?? '',
            style: TextStyle(
              color: AppColor.gray9,
              fontWeight: FontWeight.w500,
              fontSize: 12.rpx,
            ),
          ),
        ],
      ),
    );
  }
}
