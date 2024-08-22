import 'dart:convert';

import 'package:guanjia/common/extension/functions_extension.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

///红包消息内容
class MessageRedPacketContent {
  ///转账金额
  final num amount;

  ///描述文本
  final String desc;

  ///红包状态： 0待领取 1已领取 2已撤回 3已过期
  final int status;

  ///过期时间
  final int expiredTime;

  ///红包发送方
  final int fromUid;

  ///红包接收方
  final int toUid;

  ///流水号
  final int number;

  MessageRedPacketContent({
    required this.amount,
    required this.desc,
    required this.status,
    required this.expiredTime,
    required this.fromUid,
    required this.toUid,
    required this.number,
  });

  factory MessageRedPacketContent.fromJson(Map<String, dynamic> json) {
    return MessageRedPacketContent(
      amount: json['amount'],
      desc: json['desc'],
      status: json['status'],
      expiredTime: json['expiredTime'],
      fromUid: json['fromUid'],
      toUid: json['toUid'],
      number: json['number'],
    );
  }
}

///红包消息本地扩展数据
class MessageRedPacketLocal{

  ///红包状态： 0待领取 1已领取 2已撤回 3已过期
  final int status;

  ///红包领取时间
  final DateTime? receiveTime;

  MessageRedPacketLocal({required this.status, this.receiveTime});

  factory MessageRedPacketLocal.fromJson(Map<String, dynamic> json){
    int? receiveTimeMs = json['receiveTime'];
    return MessageRedPacketLocal(
        status: json['status'] ?? 0,
      receiveTime: receiveTimeMs?.let(DateTime.fromMillisecondsSinceEpoch),
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'status': status,
      'receiveTime': receiveTime?.millisecondsSinceEpoch,
    };
  }
}

extension ZIMKitMessageExtRedPacket on ZIMKitMessage {

  ///红包本地数据
  MessageRedPacketLocal get redPacketLocal {
    try{
      var jsonStr = localExtendedData.value;
      if(jsonStr.isEmpty && zim.localExtendedData.isNotEmpty){
        jsonStr = zim.localExtendedData;
      }
      return MessageRedPacketLocal.fromJson(jsonDecode(jsonStr));
    }catch(ex){
      return MessageRedPacketLocal(status: 0);
    }
  }

  ///设置红包本地数据
  Future<void> setRedPacketLocal(MessageRedPacketLocal content) {
    return ZIMKit().updateLocalExtendedData(this, jsonEncode(content.toJson()));
  }

  ///是否是待领取红包
  bool get isRedPacketReceivable => redPacketLocal.status == 0;

  set redPacketViewType(RedPacketViewType type){
    zimkitExtraInfo['viewType'] = type;
  }

  RedPacketViewType get redPacketViewType => zimkitExtraInfo['viewType'] ?? RedPacketViewType.bubble;
}

///红包界面类型
enum RedPacketViewType{
  ///气泡
  bubble,
  ///详情
  details,
  ///提示文本
  tips,
}
