import 'dart:convert';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:soundpool/soundpool.dart';
import 'package:guanjia/common/app_config.dart';
import 'package:guanjia/common/extension/date_time_extension.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/network/api/model/wish_pavilion/rosary_beads_config_model.dart';
import 'package:guanjia/common/network/api/model/wish_pavilion/rosary_beads_product_model.dart';
import 'package:guanjia/common/network/api/model/wish_pavilion/today_cultivation_stats_model.dart';
import 'package:guanjia/common/network/api/wish_pavilion_api.dart';
import 'package:guanjia/common/network/httpclient/api_response.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/widigets/merits_increment_view.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:guanjia/widgets/web/js_injector.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'rosary_beads_state.dart';

class RosaryBeadsController extends GetxController with GetAutoDisposeMixin {
  final RosaryBeadsState state = RosaryBeadsState();

  final _beginTime = DateTime.now();

  ///页面UUID
  var _pageUuid = '';

  late WebViewController webViewController;

  /// 念珠声音ID
  late int _rosaryBeadsSoundId;
  int? _rosaryBeadsStreamId;
  late Soundpool _soundPool;

  final globalKey = GlobalKey<MeritsIncrementViewState>();


  void _initialize() async {
    // 加载音效
    _soundPool = Soundpool.fromOptions(
        options: const SoundpoolOptions(
          streamType: StreamType.music,
          maxStreams: 1,
        ));

    var data = await rootBundle.load('assets/audio/佛珠.mp3');
    _rosaryBeadsSoundId = await _soundPool.load(data);
  }


  @override
  void onInit() {
    super.onInit();
    webViewController = WebViewController();
    webViewController.enableZoom(false);
    webViewController.setBackgroundColor(const Color(0xFF1A1615));
    webViewController.setJavaScriptMode(JavaScriptMode.unrestricted);
    final jsInjector = JsInjector(webViewController, onBeadsIncrement: onIncrement);
    webViewController.setNavigationDelegate(
      NavigationDelegate(
          onPageFinished: (url) => jsInjector.inject(),
          onProgress: (progress){
            if(progress == 100){
              Loading.dismiss();
            }
          }
      ),
    );
    _initialize();
    _fetchData();
  }

  void _loadWebPage({required String backgroundImg, required String beadsImg}){
    final data = Uri.encodeComponent(jsonEncode({
      'backgroundImg': backgroundImg,
      'beadsImg': beadsImg,
    }));
    webViewController.loadRequest(Uri.parse('${AppConfig.urlRosaryBeads}?data=$data'));
  }

  void _fetchData() async{
    Loading.show();
    final responses = await Future.wait<ApiResponse>([
      WishPavilionApi.getPageUuid(1),
      WishPavilionApi.getTodayCount(),
      WishPavilionApi.getRosaryBeadsConfig(),
      WishPavilionApi.getRosaryBeadsProductList(0),
      WishPavilionApi.getRosaryBeadsProductList(1),
    ]);
    if (!responses.every((element) => element.isSuccess)) {
      responses
          .firstWhereOrNull((element) => !element.isSuccess)
          ?.showErrorMessage();
      Loading.dismiss();
      return;
    }
    final pageUuidResp = responses[0] as ApiResponse<String>;
    _pageUuid = pageUuidResp.data ?? '';

    final statsResp = responses[1] as ApiResponse<TodayCultivationStatsModel>;
    state.statsRx.value = statsResp.data;

    final configResp = responses[2] as ApiResponse<RosaryBeadsConfigModel?>;
    state.configRx.value = configResp.data ?? RosaryBeadsConfigModel.fromJson({});

    //佛珠款式
    final beadListResp = responses[3] as ApiResponse<List<RosaryBeadsProductModel>>;
    final beadList = beadListResp.data?.where((element) => element.image.startsWith('http')) ?? <RosaryBeadsProductModel>[];
    var config = state.configRx();
    if(beadList.isNotEmpty){
      state.rosaryBeadsList.addAll(beadList);
      //设置默认款式
      if(config.beadsId == null || !config.beadsImg.startsWith('http')){
        final item = beadList.first;
        saveConfig(config.copyWith(
          beadsId: item.id,
          beadsImg: item.image,
        ));
      }
    }

    //默认背景
    if(config.backgroundId == null || !config.backgroundImg.startsWith('http')){
      final resp = responses[4] as ApiResponse<List<RosaryBeadsProductModel>>;
      final item = resp.data?.firstWhereOrNull((element) => element.purchase == 0 || element.isBuy == 1);
      if(item != null){
        config = config.copyWith(backgroundId: item.id, backgroundImg: item.image);
      }
    }

    if(config != state.configRx()){
      saveConfig(config);
    }
    state.isReadyRx.value = true;
    _loadWebPage(backgroundImg: state.configRx().backgroundImg, beadsImg: state.configRx().beadsImg);
  }

  ///切换音效开启,关闭
  void onTapSound() {
    final isEnabled = state.configRx().isSoundEnabled;
    saveConfig(state.configRx().copyWith(
        sound: isEnabled ? 1 : 0
    ));
  }

  ///切换交互方式
  void onTapWay() {
    final isTap = state.configRx().way == 0;
    saveConfig(state.configRx().copyWith(
        way: isTap ? 1 : 0
    ));
    if(state.configRx().way == 0){
      Loading.showToast('点击');
    }else{
      Loading.showToast('滑动');
    }
  }

  void onTapBackground() async{
    final result = await Get.toNamed(AppRoutes.rosaryBeadsBackgroundSettingPage, arguments: {
      'currentBackgroundId': state.configRx().backgroundId
    });
    if(result is RosaryBeadsProductModel){
      if(result.id != state.configRx().backgroundId){
        saveConfig(state.configRx().copyWith(
          backgroundId: result.id,
          backgroundImg: result.image,
        ));
        webViewController.runJavaScript("setBackgroundImg('${result.image}')");
      }
    }
  }

  ///切换佛珠款式
  void onTapColor() async{
    if(state.rosaryBeadsList.length <= 1){
      return;
    }
    final beadsId = state.configRx().beadsId;
    var index = state.rosaryBeadsList.indexWhere((element) => element.id == beadsId) + 1;
    if(index > state.rosaryBeadsList.length - 1){
      index = 0;
    }
    final item = state.rosaryBeadsList[index];
    saveConfig(state.configRx().copyWith(
      beadsId: item.id,
      beadsImg: item.image,
    ));
    webViewController.runJavaScript("setBeadsMaterial('${item.image}')");
  }

  void onTapLeft() {
    int? direction;
    switch(state.configRx().direction){
      case 0:
        direction = 1;
        break;
      case 2:
        direction = 0;
        break;
    }
    if(direction != null){
      saveConfig(state.configRx().copyWith(direction: direction));
    }
  }

  void onTapRight() {
    int? direction;
    switch(state.configRx().direction){
      case 0:
        direction = 2;
        break;
      case 1:
        direction = 0;
        break;
    }
    if(direction != null){
      saveConfig(state.configRx().copyWith(direction: direction));
    }
  }

  ///保存配置
  void saveConfig(RosaryBeadsConfigModel config) async{
    state.configRx.value = config;
    await WishPavilionApi.saveRosaryBeadsConfig(config);
  }

  ///提交本次记录
  void _submit() async{
    if(state.currentKnockOnRx() > 0){
      await WishPavilionApi.saveDirection(
        uuid: _pageUuid,
        count: state.currentKnockOnRx(),
        startTime: _beginTime.format,
        endTime: DateTime.now().format,
      );
    }
  }

  @override
  void onClose() {
    _submit();
    _soundPool.dispose();
    super.onClose();
  }

  void onIncrement() async{
    globalKey.currentState?.incrementRandom();
    state.currentKnockOnRx.value++;
    //播放音效
    if(state.configRx().isSoundEnabled){
      final streamId = _rosaryBeadsStreamId ?? 0;
      if(streamId > 0){
        _soundPool.stop(streamId);
      }
      _rosaryBeadsStreamId = await _soundPool.play(_rosaryBeadsSoundId);
    }
  }

}
