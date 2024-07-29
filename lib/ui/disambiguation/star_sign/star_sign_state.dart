import 'package:get/get.dart';

import '../../../common/network/api/api.dart';

class StarSignState {
  List titleTab = [
    {"name":"星座运势"},
    {"name":"星盘查询"},
    {"name":"星座配对"},
  ];

  //广播
  List<AdvertisingStartupModel> carousel = [];
  //全部星座
  List<Starts> starSignList = [
    Starts(
      icon: "assets/images/disambiguation/aries.png",
      constellation: "aries",
      name: "白羊座",
      time: "03.21-04.19"
    ),
    Starts(
        icon: "assets/images/disambiguation/taurus.png",
        constellation: "taurus",
        name: "金牛座",
        time: "03.21-04.19"
    ),
    Starts(
        icon: "assets/images/disambiguation/gemini.png",
        constellation: "gemini",
        name: "双子座",
        time: "05.21-06.21"
    ),
    Starts(
        icon: "assets/images/disambiguation/cancer.png",
        constellation: "cancer",
        name: "巨蟹座",
        time: "06.22-07.22"
    ),
    Starts(
        icon: "assets/images/disambiguation/lion.png",
        constellation: "leo",
        name: "狮子座",
        time: "07.23-08.22"
    ),
    Starts(
        icon: "assets/images/disambiguation/virgo.png",
        constellation: "virgo",
        name: "处女座",
        time: "08.23-09.22"
    ),
    Starts(
        icon: "assets/images/disambiguation/libra.png",
        constellation: "libra",
        name: "天秤座",
        time: "09.23-10.23"
    ),
    Starts(
        icon: "assets/images/disambiguation/scorpio.png",
        constellation: "scorpio",
        name: "天蝎座",
        time: "10.24-11.22"
    ),
    Starts(
        icon: "assets/images/disambiguation/shooter.png",
        constellation: "sagittarius",
        name: "射手座",
        time: "11.23-12.21"
    ),
    Starts(
        icon: "assets/images/disambiguation/capricorn.png",
        constellation: "capricorn",
        name: "摩羯座",
        time: "12.22-01.19"
    ),
    Starts(
        icon: "assets/images/disambiguation/aquarius.png",
        constellation: "aquarius",
        name: "水瓶座",
        time: "01.20-02.18"
    ),
    Starts(
        icon: "assets/images/disambiguation/pisces.png",
        constellation: "pisces",
        name: "双鱼座",
        time: "02.19-03.20"
    ),
  ];

  final titleIndex = 0.obs;//类型下标
  final starIndex = 0.obs;//星座下标
}

class Starts {
  Starts({
    String? icon,
    String? name,
    String? constellation,
    String? time,}){
    _icon = icon;
    _name = name;
    _constellation = constellation;
    _time = time;
  }

  Starts.fromJson(dynamic json) {
    _icon = json['icon'];
    _name = json['name'];
    _constellation = json['constellation'];
    _time = json['time'];
  }
  String? _icon;
  String? _name;
  String? _constellation;
  String? _time;
  Starts copyWith({  String? icon,
    String? name,
    String? constellation,
    String? time,
  }) => Starts(  icon: icon ?? _icon,
    name: name ?? _name,
    constellation: constellation ?? _constellation,
    time: time ?? _time,
  );
  String? get icon => _icon;
  String? get name => _name;
  String? get constellation => _constellation;
  String? get time => _time;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['icon'] = _icon;
    map['name'] = _name;
    map['constellation'] = _constellation;
    map['time'] = _time;
    return map;
  }

}