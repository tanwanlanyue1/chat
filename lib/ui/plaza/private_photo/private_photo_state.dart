import 'package:get/get.dart';

import '../../../generated/l10n.dart';

class PrivatePhotoState {
  //社区标题
  List communityTitle = [
    S.current.mostLike,
    S.current.bestNew,
    S.current.myFocusPhoto,
  ];
  final communityIndex = 0.obs;
  PrivatePhotoState() {
    ///Initialize variables
  }
}
