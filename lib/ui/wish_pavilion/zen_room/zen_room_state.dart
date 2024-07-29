

import 'package:get/get.dart';
import 'package:guanjia/common/network/api/model/wish_pavilion/buddha_model.dart';
import 'package:guanjia/common/network/api/model/wish_pavilion/offering_gift_info_model.dart';
import 'package:guanjia/common/network/api/model/wish_pavilion/zen_room_gift_model.dart';

class ZenRoomState {

  var isLoading = true;

  ///上一个供奉的佛
  BuddhaModel? prevBuddha;

  ///当前供奉的佛
  final selectedBuddhaRx = Rxn<BuddhaModel>();

  ///佛像列表
  final buddhaList = <BuddhaModel>[];

  ///香炉列表
  final incenseListRx = <ZenRoomGiftModel>[].obs;

  ///供品列表
  final giftListRx = <ZenRoomGiftModel>[].obs;

  ///当前已付费供奉的供品
  final offeringGiftsRx = const OfferingGiftTuple<OfferingGiftInfoModel>().obs;

  ///供桌上的供品
  final deskGiftsRx = const OfferingGiftTuple<ZenRoomGiftModel>().obs;

  ///选中的供品或者香炉
  final selectedGiftsIdRx = const OfferingGiftTuple<int>().obs;

}


class OfferingGiftTuple<T>{
  final T? left;
  final T? center;
  final T? right;
  const OfferingGiftTuple({this.left, this.center, this.right});
  OfferingGiftTuple<T> copyWithLeft(T? left){
    return OfferingGiftTuple<T>(left: left, center: center, right: right);
  }
  OfferingGiftTuple<T> copyWithCenter(T? center){
    return OfferingGiftTuple<T>(left: left, center: center, right: right);
  }
  OfferingGiftTuple<T> copyWithRight(T? right){
    return OfferingGiftTuple<T>(left: left, center: center, right: right);
  }
}

///供品扩展
extension ZenRoomGiftModelX on ZenRoomGiftModel {

  ///动效时长
  Duration? get svagDuration => null;

  ///供品类型
  ZenRoomGiftType? get giftType => ZenRoomGiftTypeX.valueOf(type);

  String get coinText {
    if(giftType == ZenRoomGiftType.gift && goldNum == 0){
      return '免费';
    }
    if (goldNum == 0) {
      if(surplusCount == 0 && afterFree > 0){
        return '$afterFree';
      }
      return '免费($surplusCount/$freeCount)';
    }
    return '$goldNum';
  }

  ///是否是免费
  bool get isFree{
    if(giftType == ZenRoomGiftType.gift && goldNum == 0){
      return true;
    }
    if (goldNum == 0) {
      return surplusCount > 0 || afterFree == 0;
    }
    return false;
  }

}

///供品类型
enum ZenRoomGiftType {
  ///1 香
  incense,

  ///2 供品
  gift,
}
extension ZenRoomGiftTypeX on ZenRoomGiftType{
  static ZenRoomGiftType? valueOf(int value){
    return ZenRoomGiftType.values.elementAtOrNull(value -1);
  }
  int get value => index + 1;

  String get label{
    switch(this){
      case ZenRoomGiftType.incense:
        return '香';
      case ZenRoomGiftType.gift:
        return '供品';
    }
  }
}