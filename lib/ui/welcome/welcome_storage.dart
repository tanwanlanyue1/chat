

import 'package:guanjia/common/utils/local_storage.dart';

class WelcomeStorage{
  static final _storage = LocalStorage('WelcomeStorage');
  static const _kIsPrivacyAgree = 'isPrivacyAgree';
  static const _kIsPrivacyVisible = 'isPrivacyVisible';
  static const _kAdDialogFirstOpen = 'adDialogFirstOpen';
  static var _isPrivacyAgree = false;
  static var _isPrivacyVisible = true;

  ///是否已同意协议
  static bool get isPrivacyAgree => _isPrivacyAgree;
  static bool get isPrivacyVisible => _isPrivacyVisible;
  WelcomeStorage._();

  static Future<void> initialize() async{
    _isPrivacyAgree = await _storage.getBool(_kIsPrivacyAgree) ?? false;
    _isPrivacyVisible = await _storage.getBool(_kIsPrivacyVisible) ?? true;
  }

  static Future<bool> savePrivacyVisible(bool value) {
    _isPrivacyVisible = value;
    return _storage.setBool(_kIsPrivacyVisible, value);
  }

  ///设置同意协议
  static Future<bool> savePrivacyAgree() {
    _isPrivacyAgree = true;
    return _storage.setBool(_kIsPrivacyAgree, true);
  }

  static Future<bool> saveAdFirstOpen(List<String> list){
    return _storage.setStringList(_kAdDialogFirstOpen, list);
  }

  static Future<List<String>> getAdFirstOpen() async{
    return (await _storage.getStringList(_kAdDialogFirstOpen)) ?? [];
  }

}