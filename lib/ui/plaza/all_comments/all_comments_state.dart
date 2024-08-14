import '../../../common/network/api/api.dart';

class AllCommentsState {
  //帖子id
  int postId = 0;
  //用户id
  int userId = 0;
  //作者信息
  UserModel authorInfo = UserModel.fromJson({});
}
