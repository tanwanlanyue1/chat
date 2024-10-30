import 'package:equatable/equatable.dart';
import 'package:guanjia/common/network/api/api.dart';

///聊天用户信息
class ChatUserModel extends Equatable {
  const ChatUserModel({
    required this.uid,
    required this.nickname,
    required this.avatar,
    required this.gender,
    required this.nameplate,
    required this.occupation,
    required this.onlineStatus,
  });

  ///	用户ID
  final String uid;

  ///	昵称
  final String nickname;

  ///	头像
  final String avatar;

  ///用户性别 0：保密 1：男 2：女
  final UserGender gender;

  ///	会员铭牌
  final String nameplate;

  ///	职业 1在职人员 2学生
  final UserOccupation occupation;

  ///在线状态 0在线 1登出 2离线
  final int onlineStatus;

  ChatUserModel copyWith({
    String? uid,
    String? nickname,
    String? avatar,
    UserGender? gender,
    String? nameplate,
    UserOccupation? occupation,
    int? onlineStatus,
  }) {
    return ChatUserModel(
      uid: uid ?? this.uid,
      nickname: nickname ?? this.nickname,
      avatar: avatar ?? this.avatar,
      gender: gender ?? this.gender,
      nameplate: nameplate ?? this.nameplate,
      occupation: occupation ?? this.occupation,
      onlineStatus: onlineStatus ?? this.onlineStatus,
    );
  }

  factory ChatUserModel.fromJson(Map<String, dynamic> json){
    return ChatUserModel(
      uid: json["uid"] ?? "",
      nickname: json["nickname"] ?? "",
      avatar: json["avatar"] ?? "",
      gender: UserGender.valueForIndex(json["gender"] ?? 0),
      nameplate: json["nameplate"] ?? "",
      occupation: UserOccupation.valueForIndex(json["occupation"] ?? 0),
      onlineStatus: json["onlineStatus"] ?? 0,
    );
  }

  @override
  List<Object?> get props => [
    uid, nickname, avatar, gender, nameplate, occupation, onlineStatus, ];
}
