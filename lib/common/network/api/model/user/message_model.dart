import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:guanjia/common/extension/functions_extension.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/extension/string_extension.dart';
import 'package:guanjia/common/utils/app_logger.dart';

import '../../api.dart';

///系统消息
class MessageModel {
  MessageModel({
      this.id,
    //用户ID
    this.uid,
    //系统消息id
    this.msgId,
    //消息类型:0系统消息，1赞，2收藏，3评论，4回复评论，5新增关注
    this.type,
    //未读：0，已读：1
    this.read,
    //消息内容
    this.content,
    //用户-消息-扩展字段
    this.extraJson,
    //	创建时间
    this.createTime,
    //广场-动态详情
    this.post,
    //广场-帖子评论
    this.comment,
    //广场-帖子评论
    this.replyComment,
    //用户信息
    this.userInfo,
    //系统-消息
    this.systemMessage,
    //选择
    this.isSelect = false,
  });

  MessageModel.fromJson(dynamic json) {
    id = json['id'];
    uid = json['uid'];
    msgId = json['msgId'];
    type = json['type'];
    read = json['read'];
    content = json['content'];
    extraJson = json['extraJson'] != null ? ExtraJson.fromJson(json['extraJson']) : null;
    createTime = json['createTime'];
    isSelect = json['isSelect'] ?? false;
    post = json['post'] != null ? PlazaListModel.fromJson(json['post']) : null;
    comment = json['comment'] != null ? CommentListModel.fromJson(json['comment']) : null;
    replyComment = json['replyComment'] != null ? CommentListModel.fromJson(json['replyComment']) : null;
    userInfo = json['userInfo'] != null ? UserModel.fromJson(json['userInfo']) : null;
    systemMessage = json['systemMessage'] != null ? SystemMessage.fromJson(json['systemMessage']) : null;
  }
  int? id;
  int? uid;
  int? msgId;
  int? type;
  int? read;
  bool? isSelect;
  String? content;
  ExtraJson? extraJson;
  int? createTime;
  PlazaListModel? post;
  CommentListModel? comment;
  CommentListModel? replyComment;
  UserModel? userInfo;
  SystemMessage? systemMessage;
}

class SystemMessage {
  SystemMessage({
      this.id, 
      this.type, 
      this.title, 
      this.content, 
      this.action, 
      this.extraJson,
      this.jumpType,
      this.link,
      this.createTime,});

  SystemMessage.fromJson(dynamic json) {
    Map? extraMap;
    final extraJsonStr = json['extraJson'];
    if (extraJsonStr is String) {
      try {
        extraMap = jsonDecode(extraJsonStr);
        final extra = extraMap?.getStringOrNull('extra');
        if(extra != null){
          extra.toJson()?.let((value){
            extraMap?.remove('extra');
            extraMap?.addAll(value);
          });
        }
      } catch (ex) {
        AppLogger.w('SystemMessage.fromJson ex=$ex');
      }
    }


    id = json['id'];
    type = json['type'];
    title = json['title'];
    content = json['content'];
    action = json['action'];
    link = json['link'];
    extraJson = extraMap?.map((key, value) => MapEntry(key.toString(), value));
    jumpType = json['jumpType'];
    createTime = json['createTime'];
  }
  int? id;
  int? type;
  /// 跳转类型（0无 1外链 2内页）
  int? jumpType;
  String? title;
  String? content;
  String? action;
  /// 跳转链接
  String? link;
  Map<String,dynamic>? extraJson;
  int? createTime;


  String? get image{
    return extraJson?.getStringOrNull('image');
  }

  //#FF07FF
  Color? get color{
    final hex = extraJson?.getStringOrNull('color');
    return hex?.color;
  }


}

class ExtraJson {
  ExtraJson({
      this.postId, 
      this.uid, 
      this.commentId, 
      this.replyCommentId,});

  ExtraJson.fromJson(dynamic json) {
    postId = json['postId'];
    uid = json['uid'];
    commentId = json['commentId'];
    replyCommentId = json['replyCommentId'];
  }
  int? postId;
  int? uid;
  int? commentId;
  int? replyCommentId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['postId'] = postId;
    map['uid'] = uid;
    map['commentId'] = commentId;
    map['replyCommentId'] = replyCommentId;
    return map;
  }

}