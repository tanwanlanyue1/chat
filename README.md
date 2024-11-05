# talk_fo_me

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## flutter version 3.19.5

## 命名规范
页面 Page
对话框 Dialog
底部弹出框 BottomSheet

## 环境变量
export PATH=$HOME/flutter3.19.5/bin:$PATH

## 打测试包 
flutter build apk --dart-define=APP_CHANNEL=official
flutter build ipa --export-method ad-hoc --dart-define=APP_CHANNEL=appstore

## 打正式包
将app/build.gradle的ndk abiFilters 配置打开
flutter build apk --dart-define=APP_RELEASE=release --dart-define=APP_CHANNEL=official
flutter build ipa --dart-define=APP_RELEASE=release --dart-define=APP_CHANNEL=appstore

## 查看Android证书SHA
keytool -list -v -keystore guanjia.jks



## iOS测试打包
flutter build ipa --export-method ad-hoc

## iOS打正式包
flutter build ipa --dart-define=APP_CHANNEL=0 --dart-define=APP_RELEASE=release