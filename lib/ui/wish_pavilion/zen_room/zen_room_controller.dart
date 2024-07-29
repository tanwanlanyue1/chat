import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/extension/functions_extension.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/extension/string_extension.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/network/httpclient/api_response.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/local_storage.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/widigets/merits_increment_view.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/widigets/zen_meditation_dialog.dart';
import 'package:guanjia/widgets/ad_dialog.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:guanjia/widgets/widgets.dart';

import 'choose_buddha/choose_buddha_page.dart';
import 'utils/chant_sutras_player_controller.dart';
import 'widigets/zen_room_gift_panel.dart';
import 'zen_room_3d_mixin.dart';
import 'zen_room_state.dart';

class ZenRoomController extends GetxController with GetAutoDisposeMixin, ZenRoom3DMixin{
  final ZenRoomState state = ZenRoomState();
  final _localStorage = LocalStorage('ZenRoom');

  ///佛ID
  static const _kBuddhaId = '_kBuddhaId';

  ///诵经控制器
  final chantSutrasController = ChantSutrasPlayerController();
  final globalKey = GlobalKey<MeritsIncrementViewState>();

  @override
  void onInit() {
    super.onInit();
    chantSutrasController.initialize();
    _fetchData();
    if(SS.login.isLogin){
      SS.login.fetchLevelMoneyInfo();
    }
  }

  Future<void> _fetchData({bool refresh = false, int? buddhaId}) async {
    if(!refresh){
      Loading.show();
    }

    //当前供奉的佛像ID
    if(buddhaId == null){
      final response = await WishPavilionApi.getOfferingBuddha();
      if (!response.isSuccess) {
        Loading.dismiss();
        response.showErrorMessage();
        // return;
      }
      // buddhaId =
      //     response.data?.id ?? await _localStorage.getInt(_kBuddhaId);
      buddhaId = response.data?.id;
    }

    final responses = await Future.wait<ApiResponse>([
      WishPavilionApi.getBuddhaList(),
      WishPavilionApi.getZenRoomGiftList(type: 1, page: 1, size: 100),
      WishPavilionApi.getZenRoomGiftList(type: 2, page: 1, size: 100),
      if (buddhaId != null) WishPavilionApi.getOfferingGifts(buddhaId)
    ]);
    Loading.dismiss();
    state.isLoading = false;
    startupCarousel();
    update();
    if (!responses.every((element) => element.isSuccess)) {
      responses
          .firstWhereOrNull((element) => !element.isSuccess)
          ?.showErrorMessage();
      return;
    }

    //佛像列表
    final buddhaListResp = responses[0] as ApiResponse<List<BuddhaModel>>;
    state.buddhaList
      ..clear()
      ..addAll(buddhaListResp.data ?? []);

    //香炉 + 供品 列表
    final incenseListResp = responses[1] as ApiResponse<List<ZenRoomGiftModel>>;
    final giftListResp = responses[2] as ApiResponse<List<ZenRoomGiftModel>>;
    state.incenseListRx.value = incenseListResp.data ?? [];
    state.giftListRx.value = giftListResp.data ?? [];
    if(buddhaId == null){
      return;
    }

    //当前供奉的佛像
    state.selectedBuddhaRx.value = state.buddhaList
        .firstWhereOrNull((element) => element.id == buddhaId);

    //供品数据
    final giftsResp =
        responses[3] as ApiResponse<List<OfferingGiftInfoModel>>;
    var offeringGifts = const OfferingGiftTuple<OfferingGiftInfoModel>();
    giftsResp.data?.where((element) => element.status == 0).forEach((element) {
      switch (element.direction) {
        case 0:
          offeringGifts = offeringGifts.copyWithLeft(element);
          break;
        case 1:
          offeringGifts = offeringGifts.copyWithRight(element);
          break;
        case null:
          offeringGifts = offeringGifts.copyWithCenter(element);
          break;
      }
    });

    //已付费供品数据
    state.offeringGiftsRx.value = offeringGifts;

    //供桌上显示的供品
    state.deskGiftsRx.value = OfferingGiftTuple<ZenRoomGiftModel>(
      left: state.giftListRx().firstWhereOrNull(
              (element) => element.id == offeringGifts.left?.giftId),
      center: state.incenseListRx().firstWhereOrNull(
              (element) => element.id == offeringGifts.center?.giftId),
      right: state.giftListRx().firstWhereOrNull(
              (element) => element.id == offeringGifts.right?.giftId),
    );
    update();
  }

  ///选择佛像
  void onTapChooseBuddha() => SS.login.requiredAuthorized(() async{
    if (state.buddhaList.isEmpty) {
      Loading.showToast('佛像列表为空');
      return;
    }
    final buddha = await ChooseBuddhaPage.go(
        selectedId: state.selectedBuddhaRx()?.id, buddhaList: state.buddhaList);
    if (buddha != null && buddha.id != state.selectedBuddhaRx()?.id) {
      state.prevBuddha = state.selectedBuddhaRx();
      state.selectedBuddhaRx.value = buddha;
      await _localStorage.setInt(_kBuddhaId, buddha.id);
      _fetchData(buddhaId: buddha.id);
    }
  });


  ///选中供品、香炉
  void onSelectedGift(ZenRoomGiftModel item, GiftPanelTabItem tab) => SS.login.requiredAuthorized((){
    if (state.selectedBuddhaRx() == null) {
      Loading.showToast('请先恭请佛像');
      return;
    }
    final deskGifts = state.deskGiftsRx();
    final offeringGifts = state.offeringGiftsRx();
    final selectedGiftsId = state.selectedGiftsIdRx();

    //已购买的供品
    final offeringDeskGifts = OfferingGiftTuple<ZenRoomGiftModel>(
      left: state.giftListRx().firstWhereOrNull(
              (element) => element.id == offeringGifts.left?.giftId),
      center: state.incenseListRx().firstWhereOrNull(
              (element) => element.id == offeringGifts.center?.giftId),
      right: state.giftListRx().firstWhereOrNull(
              (element) => element.id == offeringGifts.right?.giftId),
    );

    switch(tab){
      case GiftPanelTabItem.incense:
        if(item.id == selectedGiftsId.center){
          //取消选中
          state.selectedGiftsIdRx.value = selectedGiftsId.copyWithCenter(null);
          state.deskGiftsRx.value = deskGifts.copyWithCenter(offeringDeskGifts.center);
        }else{
          //选中
          state.selectedGiftsIdRx.value = selectedGiftsId.copyWithCenter(item.id);
          state.deskGiftsRx.value = deskGifts.copyWithCenter(item);
        }
        break;
      case GiftPanelTabItem.leftGift:
        final left = offeringDeskGifts.left;
        //相同的供品不能顶替、免费不能替换付费供品
        if(left?.id == item.id || (item.goldNum == 0 && (left?.goldNum ?? 0) > 0)){
          Loading.showToast('无法再顶礼，需等时效');
          return;
        }
        if(item.id == selectedGiftsId.left){
          //取消选中
          state.selectedGiftsIdRx.value = selectedGiftsId.copyWithLeft(null);
          state.deskGiftsRx.value = deskGifts.copyWithLeft(offeringDeskGifts.left);
        }else{
          //选中
          state.selectedGiftsIdRx.value = selectedGiftsId.copyWithLeft(item.id);
          state.deskGiftsRx.value = deskGifts.copyWithLeft(item);
        }
        break;
      case GiftPanelTabItem.rightGift:
        final right = offeringDeskGifts.right;
        //相同的供品不能顶替、免费不能替换付费供品
        if(right?.id == item.id || (item.goldNum == 0 && (right?.goldNum ?? 0) > 0)){
          Loading.showToast('无法再顶礼，需等时效');
          return;
        }
        if(item.id == selectedGiftsId.right){
          //取消选中
          state.selectedGiftsIdRx.value = selectedGiftsId.copyWithRight(null);
          state.deskGiftsRx.value = deskGifts.copyWithRight(offeringDeskGifts.right);
        }else{
          //选中
          state.selectedGiftsIdRx.value = selectedGiftsId.copyWithRight(item.id);
          state.deskGiftsRx.value = deskGifts.copyWithRight(item);
        }
        break;
      default:
        break;
    }

  });

  ///刷新已购买的供品列表，去掉已过期的供品
  void refreshOfferingGifts() {
    final offeringGifts = state.offeringGiftsRx();
    final now = DateTime.now();

    OfferingGiftInfoModel? checkOfferingGift(OfferingGiftInfoModel? item){
      if(item != null && item.endTime.dateTime?.isBefore(now) == true){
        return null;
      }
      return item;
    }

    final left = checkOfferingGift(offeringGifts.left);
    final center = checkOfferingGift(offeringGifts.center);
    final right = checkOfferingGift(offeringGifts.right);

    //无失效数据
    if(offeringGifts.left == left && offeringGifts.center == center && offeringGifts.right == right){
      return;
    }
    state.offeringGiftsRx.value = OfferingGiftTuple<OfferingGiftInfoModel>(
      left: left,
      center: center,
      right: right,
    );


    ZenRoomGiftModel? checkGift(ZenRoomGiftModel? item, OfferingGiftInfoModel? offeringItem, int? selectedId){
      if(item != null && item.id != offeringItem?.giftId && item.id != selectedId){
        return null;
      }
      return item;
    }

    final selectedGiftsId = state.selectedGiftsIdRx();
    final deskGifts = state.deskGiftsRx();
    final deskLeft = checkGift(deskGifts.left, left, selectedGiftsId.left);
    final deskCenter = checkGift(deskGifts.center, center, selectedGiftsId.center);
    final deskRight = checkGift(deskGifts.right, right, selectedGiftsId.right);
    if(deskGifts.left == deskLeft && deskGifts.center == deskCenter && deskGifts.right == deskRight){
      return;
    }

    //刷新供桌上的供品数据
    state.deskGiftsRx.value = OfferingGiftTuple<ZenRoomGiftModel>(
      left: deskLeft,
      center: deskCenter,
      right: deskRight,
    );
  }

  ///点击禅垫，获取禅语
  void fetchZenLanguage() async{
    Loading.show();
    final response = await WishPavilionApi.getZenLanguage();
    Loading.dismiss();
    if(response.isSuccess){
      response.data?.let(ZenMeditationDialog.show);
    }else{
      response.showErrorMessage();
    }
  }

  ///顶礼
  void onSubmit(GiftPanelTabItem tab) async {
    final buddha = state.selectedBuddhaRx();
    if (buddha == null) {
      Loading.showToast('请先恭请佛像');
      return;
    }
    final selectedGiftsId = state.selectedGiftsIdRx();
    final deskGifts = state.deskGiftsRx();
    int? direction;
    ZenRoomGiftModel? gift;
    switch(tab){
      case GiftPanelTabItem.incense:
        gift = deskGifts.center;
        break;
      case GiftPanelTabItem.leftGift:
        gift = deskGifts.left;
        direction = 0;
        break;
      case GiftPanelTabItem.rightGift:
        gift = deskGifts.right;
        direction = 1;
        break;
      default:
        break;
    }

    if (gift == null) {
      Loading.showToast('请选择${tab == GiftPanelTabItem.incense ? "供品" : "香"}');
      return;
    }

    Loading.show();
    final response = await WishPavilionApi.offering(
      buddhaId: buddha.id,
      giftId: gift.id,
      direction: direction,
    );
    if (response.isSuccess) {
      await _fetchData(refresh: true);

      //顶礼成功后，取消选中
      switch(tab){
        case GiftPanelTabItem.incense:
          state.selectedGiftsIdRx.value = selectedGiftsId.copyWithCenter(null);
          break;
        case GiftPanelTabItem.leftGift:
          state.selectedGiftsIdRx.value = selectedGiftsId.copyWithLeft(null);
          break;
        case GiftPanelTabItem.rightGift:
          state.selectedGiftsIdRx.value = selectedGiftsId.copyWithRight(null);
          break;
        default:
          break;
      }

      //刷新余额
      if(gift.goldNum > 0 || (gift.surplusCount == 0 && gift.afterFree > 0)){
        SS.login.fetchLevelMoneyInfo();
      }
      var msg = gift.remark.trim();
      if(msg.isEmpty){
        msg = '顶礼成功';
      }
      Loading.showToast(msg);
      //加功德特效
      globalKey.currentState?.increment(value: gift.mavNum);
    } else {
      Loading.dismiss();
      response.showErrorMessage();
    }
  }

  /// 获取广告弹窗
  void startupCarousel() async {
    final response = await OpenApi.startupAdvertList(
        type: 3,
        position: 8,
        size: 1
    );
    if (response.isSuccess) {
      if(response.data?.isNotEmpty ?? false){
        AppAdDialog.show(response.data![0],"8");
      }
    }
  }
  @override
  void onClose() {
    chantSutrasController.dispose();
    super.onClose();
  }
}
