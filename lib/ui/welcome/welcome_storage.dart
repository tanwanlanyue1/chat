

import 'package:guanjia/common/utils/local_storage.dart';

class WelcomeStorage{
  static final _storage = LocalStorage('WelcomeStorage');
  static const _kIsPrivacyAgree = 'isPrivacyAgree';
  static const _kAdDialogFirstOpen = 'adDialogFirstOpen';
  static var _isPrivacyAgree = false;
  
  ///是否已同意协议
  static bool get isPrivacyAgree => _isPrivacyAgree;
  WelcomeStorage._();

  static Future<bool> initialize(){
    return _storage.getBool(_kIsPrivacyAgree).then((value) => _isPrivacyAgree = value ?? false);
  }

  ///设置同意协议
  static Future<bool> savePrivacyAgree() {
    return _storage.setBool(_kIsPrivacyAgree, true);
  }

  static Future<bool> saveAdFirstOpen(List<String> list){
    return _storage.setStringList(_kAdDialogFirstOpen, list);
  }

  static Future<List<String>> getAdFirstOpen() async{
    return (await _storage.getStringList(_kAdDialogFirstOpen)) ?? [];
  }

}