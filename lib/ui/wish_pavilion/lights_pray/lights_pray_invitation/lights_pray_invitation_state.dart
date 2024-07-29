import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';

class LightsPrayInvitationState {
  // 生辰
  final birthday = "".obs;

  // 当前选中供灯类型
  final selectIndex = 0.obs;

  // 是否公开
  final isOpen = true.obs;

  // 供灯数据
  final lights = <GiftModel>[].obs;

  final defaultContent = "愿以此功德，庄严佛净土。上报四重恩，下济三途苦。若有见闻者，悉发菩提心。尽此一报身，同生极乐国。";
}
