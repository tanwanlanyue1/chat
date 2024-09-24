import 'package:get/get.dart';
import 'package:guanjia/common/network/api/model/talk_model.dart';
import 'package:guanjia/generated/l10n.dart';

class UserCenterState {
  //作者id
  int authorId = 0;

  final isAppBarExpanded = false.obs;

  final isShow = true.obs;
  //作者信息
  UserModel authorInfo = UserModel.fromJson({});
  int swiperIndex = 0;
  //上传封面图
  List<String> imgList = [];

  //用户基础信息
  List userBasics = [
    {
      "name": S.current.userAge,
      "data":"age",
    },
    {
      "name": S.current.userGender,
      "data":"gender",
    },
    {
      "name": S.current.favorableRate,
      "data":"praiseRate",
    },
    {
      "name": S.current.numberTransactions,
      "data":"dealNum",
    },
  ];
}
