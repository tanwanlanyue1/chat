
class GeocodeModel {
  GeocodeModel({
    required this.plusCode,
    required this.results,
    required this.status,
  });

  /// 最接近查询的纬度和经度的结果
  final PlusCode? plusCode;
  final List<GeocodeResult> results;

  /*
  "OK" 表示未发生任何错误，并且至少有 1 个 地址。
  "ZERO_RESULTS"，表示反向地理编码 成功，但未返回任何结果。如果向地理编码器传递了某个偏远位置的 latlng，就可能会发生这种情况。
  "OVER_QUERY_LIMIT"表示您已超出 配额。
  "REQUEST_DENIED" 表示请求已被拒绝。 这可能是因为该请求包含了 result_type 或 location_type 参数，但未包含 API 密钥。
  "INVALID_REQUEST" 通常表示下列情况之一：
  缺少查询参数（address、components 或 latlng）。
  提供的 result_type 或 location_type 无效。
  "UNKNOWN_ERROR" 表示因服务器错误而无法处理该请求。如果您重试一次，请求可能会成功。
   */
  final String status;

  bool get isSuccess => ['OK', 'ZERO_RESULTS'].contains(status);

  factory GeocodeModel.fromJson(Map<String, dynamic> json){
    return GeocodeModel(
      plusCode: json["plus_code"] == null ? null : PlusCode.fromJson(json["plus_code"]),
      results: json["results"] == null ? [] : List<GeocodeResult>.from(json["results"]!.map((x) => GeocodeResult.fromJson(x))),
      status: json["status"] ?? "",
    );
  }

}

class PlusCode {
  PlusCode({
    required this.compoundCode,
    required this.globalCode,
  });

  final String compoundCode;
  final String globalCode;

  factory PlusCode.fromJson(Map<String, dynamic> json){
    return PlusCode(
      compoundCode: json["compound_code"] ?? "",
      globalCode: json["global_code"] ?? "",
    );
  }

}

class GeocodeResult {
  GeocodeResult({
    required this.addressComponents,
    required this.formattedAddress,
    required this.geometry,
    required this.placeId,
    required this.plusCode,
    required this.types,
  });

  final List<AddressComponent> addressComponents;

  ///是一个字符串，其中包含此位置直观易懂的地址
  final String formattedAddress;

  ///地理位置信息
  final Geometry? geometry;
  final String placeId;
  final PlusCode? plusCode;
  final List<String> types;

  factory GeocodeResult.fromJson(Map<String, dynamic> json){
    return GeocodeResult(
      addressComponents: json["address_components"] == null ? [] : List<AddressComponent>.from(json["address_components"]!.map((x) => AddressComponent.fromJson(x))),
      formattedAddress: json["formatted_address"] ?? "",
      geometry: json["geometry"] == null ? null : Geometry.fromJson(json["geometry"]),
      placeId: json["place_id"] ?? "",
      plusCode: json["plus_code"] == null ? null : PlusCode.fromJson(json["plus_code"]),
      types: json["types"] == null ? [] : List<String>.from(json["types"]!.map((x) => x)),
    );
  }

}

class AddressComponent {
  AddressComponent({
    required this.longName,
    required this.shortName,
    required this.types,
  });

  final String longName;
  final String shortName;
  final List<String> types;

  factory AddressComponent.fromJson(Map<String, dynamic> json){
    return AddressComponent(
      longName: json["long_name"] ?? "",
      shortName: json["short_name"] ?? "",
      types: json["types"] == null ? [] : List<String>.from(json["types"]!.map((x) => x)),
    );
  }

}

class Geometry {
  Geometry({
    required this.location,
    required this.locationType,
    required this.viewport,
    required this.bounds,
  });

  final Location? location;
  final String locationType;
  final Bounds? viewport;
  final Bounds? bounds;

  factory Geometry.fromJson(Map<String, dynamic> json){
    return Geometry(
      location: json["location"] == null ? null : Location.fromJson(json["location"]),
      locationType: json["location_type"] ?? "",
      viewport: json["viewport"] == null ? null : Bounds.fromJson(json["viewport"]),
      bounds: json["bounds"] == null ? null : Bounds.fromJson(json["bounds"]),
    );
  }

}

class Bounds {
  Bounds({
    required this.northeast,
    required this.southwest,
  });

  final Location? northeast;
  final Location? southwest;

  factory Bounds.fromJson(Map<String, dynamic> json){
    return Bounds(
      northeast: json["northeast"] == null ? null : Location.fromJson(json["northeast"]),
      southwest: json["southwest"] == null ? null : Location.fromJson(json["southwest"]),
    );
  }

}

class Location {
  Location({
    required this.lat,
    required this.lng,
  });

  final double lat;
  final double lng;

  factory Location.fromJson(Map<String, dynamic> json){
    return Location(
      lat: json["lat"] ?? 0.0,
      lng: json["lng"] ?? 0.0,
    );
  }

}
