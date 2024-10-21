///位置消息内容
class MessageLocationContent {

  ///经度
  final double longitude;

  ///纬度
  final double latitude;

  ///地址
  final String address;

  MessageLocationContent({
    required this.longitude,
    required this.latitude,
    required this.address,
  });

  factory MessageLocationContent.fromJson(Map<String, dynamic> json) {
    return MessageLocationContent(
      longitude: json['longitude'] ?? 0,
      latitude: json['latitude'] ?? 0,
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'longitude': longitude,
      'latitude': latitude,
      'address': address,
    };
  }

}
