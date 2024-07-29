import 'package:get/get.dart';
import 'package:guanjia/common/network/api/model/talk_model.dart';


class PlazaDetailState {
  //作者信息
  final authorInfo = UserModel.fromJson({}).obs;
  //文章id
  int communityId = 0;
  //作者id
  int authorId = 0;
  ///评论的根id
  int? rootId;
  ///评论回复的id
  int? replyId;
  ///评论总数
  int? commentCount;
  //回复的人
  String? hint;
  //文章详情
  PlazaListModel articleDetail = PlazaListModel.fromJson({});
  //某一条评论下的全部评论
  final review = CommentListModel.fromJson({}).obs;
  //是否关注作者
  bool? isAttention;
  final List dropData = [
    {"name":'热门',"type":0},
    {"name":'最新',"type":1},
    {"name":'最早',"type":2},
  ];
  final dropValuer = "热门".obs;
  //评论类型
  int dropType = 0;
}
