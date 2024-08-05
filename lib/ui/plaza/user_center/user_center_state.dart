import 'dart:io';

import 'package:get/get.dart';
import 'package:guanjia/common/network/api/model/talk_model.dart';

class UserCenterState {
  //作者id
  int authorId = 0;
  //是否关注
  bool isAttention = false;

  final isAppBarExpanded = false.obs;
  //作者信息
  // UserModel authorInfo = UserModel.fromJson({});
  //创作数
  Map creation = {};
  //上传封面图
  List<File> imgList = [];
  //用户基础信息
  List userBasics = [
    {
      "name":"年龄",
      "data":"22",
    },
    {
      "name":"性别",
      "data":"女",
    },
    {
      "name":"好评率",
      "data":"98%",
    },
    {
      "name":"成交单数",
      "data":"22",
    },
  ];
}
