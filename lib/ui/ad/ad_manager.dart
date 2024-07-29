import 'dart:io';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/utils/local_storage.dart';
import 'ad_file_cache.dart';

///广告管理
class ADManager {
  ADManager._();

  static final instance = ADManager._();
  static const _kLaunchAds = 'LaunchAds';
  final _sharedPreferences = LocalStorage('ADManager');
  var _isInitialized = false;

  ///APP启动开屏广告
  late AdvertisingStartupModel _launchAds =
      AdvertisingStartupModel.fromJson({});

  ///本次打开app需要显示的广告文件
  File? _launchAdFile;

  ///初始化
  Future<void> initialize() async {
    try {
      if (_isInitialized) {
        return;
      }
      _isInitialized = true;
      await _loadLocalData();
      _fetchRemoteData().ignore();
    } catch (e) {
      print("e==$e");
    }
  }

  ///当前需要显示的开屏广告
  AdvertisingStartupModel? getLaunchAd() {
    //TODO 目前仅支持图片广告
    if (_launchAds.type != 1) {
      return null;
    }
    return _launchAds;
  }

  ///当前需要显示的开屏广告文件
  File? getLaunchAdFile() => _launchAdFile;

  ///加载本地数据
  Future<void> _loadLocalData() async {
    final data = await _getLaunchAds();
    _launchAds = data.isEmpty ? AdvertisingStartupModel.fromJson({}) : data[0];
    final ad = getLaunchAd();
    if (ad != null) {
      _launchAdFile = await AdFileCache.instance.getFile(ad.gotoUrl!);
    }
  }

  ///获取远程数据
  Future<void> _fetchRemoteData() async {
    final response = await OpenApi.startupAdvertList();
    if (response.isSuccess) {
      final data = response.data ?? [];
      if (data.isEmpty) return;
      _launchAds = data[0];
      _saveLaunchAds(data);
      _preloadLaunchAdImage();
    }
  }

  ///预加载启动广告图片到缓存
  void _preloadLaunchAdImage() {
    final ad = getLaunchAd();
    if (ad != null && ad.image != null && ad.image!.startsWith('http')) {
      AdFileCache.instance.downloadFile(ad.image!);
    }
  }

  ///保存开屏广告列表
  Future<bool> _saveLaunchAds(List<AdvertisingStartupModel> list) async {
    final jsonArray = list.map((e) => e.toJson()).toList();
    return _sharedPreferences.setJsonArray(_kLaunchAds, jsonArray);
  }

  ///获取本地开屏广告列表
  Future<List<AdvertisingStartupModel>> _getLaunchAds() async {
    final list = await _sharedPreferences.getJsonArray(_kLaunchAds);
    if (list != null && list.isNotEmpty) {
      return list.map(AdvertisingStartupModel.fromJson).toList();
    }
    return [];
  }
}
