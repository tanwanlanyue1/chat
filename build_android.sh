#!/bin/sh

# 渠道类型（appstore:Apple Store,huawei:华为，360:360，baidu:百度，oppo:oppo，ali:阿里，xiaomi:小米， official:官方下载 vivo:VIVO ,honour:荣耀）
# 批量打正式包 for i in {huawei,360,baidu,oppo,ali,xiaomi,official,vivo,honour}; do ./build_android.sh $i release; done
# 测试包 ./build_android.sh xiaomi
# 正式包 ./build_android.sh xiaomi release

# 语言版本，默认为空（中文版）
LANGUAGE=""
# 打包格式，默认为apk,打包appbundle,请输入aab
FORMAT=""

filePath="build/app/outputs/apk/release/app-release.apk"

packagesPath="apks/"
channelMap="appstore=Apple Store;huawei=华为;360=360;baidu=百度;oppo=oppo;ali=阿里;xiaomi=小米;official=官方;vivo=VIVO;honour=荣耀"

# 使用 awk 来从 channelMap 字符串中获取指定键的值
channelName=$(echo "$channelMap" | awk -F";" -v k="$1" '{
    for(i=1; i<=NF; i++) {
        split($i, a, "=");
        if (a[1] == k) {
            print a[2];
            exit;  # 找到匹配的键后退出循环
        }
    }
}')

release=""
language=""
# aab
packageFormat="apk"
# appbundle
packageCommand="apk"

# echo "请输入安卓包格式(任意键为apk,打包appbundle,请输入aab):"
# read input

if [[ $FORMAT == "aab" ]]; then
  packageFormat="aab"
  packageCommand="appbundle"
  filePath="build/app/outputs/bundle/release/app-release.aab"
fi

if [[ "$LANGUAGE" =~ \ |\' ]]; then
  echo "LANGUAGE不能带空格"
else
  if [[ ${#LANGUAGE} > 0 ]]; then
    language="--dart-define=APP_LANGUAGE=$LANGUAGE"
    echo "语言:$LANGUAGE"
    packagesPath=$LANGUAGE"apks/"
  fi
fi

if [ $1 ]; then
  if [[ $2 && $2 == "release" ]]; then
    release="--dart-define=APP_RELEASE=release"
    echo "发布包"
  fi

  if [ ! -d "$packagesPath" ]; then
    echo "创建安装包文件夹:$packagesPath"
    mkdir "$packagesPath"
  fi

  # 渠道包
  echo "编译安卓,channel:$1(${channelName})"
  echo "flutter build $packageCommand --dart-define=APP_CHANNEL=$1 $release $language"
  flutter build $packageCommand --dart-define=APP_CHANNEL=$1 $release $language

  if [ -f "$filePath" ]; then
    if [[ $2 && $2 == "release" ]]; then
      mv -f "$filePath" "$packagesPath""app-official-release_${channelName}"".$packageFormat"
      echo "安卓发布包打包成功:""$packagesPath""app-official-release_${channelName}"".$packageFormat"
    else
      mv -f "$filePath" "$packagesPath""app-release_${channelName}"".$packageFormat"
      echo "安卓打包成功:""$packagesPath""app-release_${channelName}"".$packageFormat"
    fi

    open "$packagesPath"
  else
    echo "安卓打包失败,未找到有效安装包"
  fi
else
  if [ ! -d "$packagesPath" ]; then
    echo "创建安装包文件夹:$packagesPath"
    mkdir "$packagesPath"
  fi

  # 非渠道包
  echo "编译安卓,非渠道包"
  echo "flutter build $packageCommand $language"
  flutter build $packageCommand $language

  if [ -f "$filePath" ]; then
    mv -f "$filePath" "$packagesPath""app-release"".$packageFormat"
    echo "安卓非渠道包打包成功:""$packagesPath""app-release"".$packageFormat"

    open "$packagesPath"
  else
    echo "安卓打包失败,未找到有效安装包"
  fi
fi
