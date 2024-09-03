import 'package:get/get.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/generated/l10n.dart';

class FortuneSquareState {
  final userInfo = SS.login.info;

  //社区标题
  List communityTitle = [
    S.current.plaza,
    S.current.myFocus,
    S.current.myPost,
  ];
}
