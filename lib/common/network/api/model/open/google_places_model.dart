
///地点Model
class GooglePlacesModel {
  GooglePlacesModel({
    required this.htmlAttributions,
    required this.nextPageToken,
    required this.results,
    required this.status,
  });

  final List<String> htmlAttributions;
  final String nextPageToken;

  ///结果
  final List<PlaceModel> results;

  /*
  OK indicating the API request was successful.
  ZERO_RESULTS indicating that the search was successful but returned no results. This may occur if the search was passed a latlng in a remote location.
  INVALID_REQUEST indicating the API request was malformed, generally due to missing required query parameter (location or radius).
  OVER_QUERY_LIMIT indicating any of the following:
  You have exceeded the QPS limits.
  Billing has not been enabled on your account.
  The monthly $200 credit, or a self-imposed usage cap, has been exceeded.
  The provided method of payment is no longer valid (for example, a credit card has expired).
  See the Maps FAQ for more information about how to resolve this error.
  REQUEST_DENIED indicating that your request was denied, generally because:
  The request is missing an API key.
  The key parameter is invalid.
  UNKNOWN_ERROR indicating an unknown error.
   */
  final String status;

  ///是否成功
  bool get isSuccess => ['OK', 'ZERO_RESULTS'].contains(status);

  factory GooglePlacesModel.fromJson(Map<String, dynamic> json){
    return GooglePlacesModel(
      htmlAttributions: json["html_attributions"] == null ? [] : List<String>.from(json["html_attributions"]!.map((x) => x)),
      nextPageToken: json["next_page_token"] ?? "",
      results: json["results"] == null ? [] : List<PlaceModel>.from(json["results"]!.map((x) => PlaceModel.fromJson(x))),
      status: json["status"] ?? "",
    );
  }

}

///地点
class PlaceModel {

  PlaceModel({
    required this.geometry,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconMaskBaseUri,
    required this.name,
    required this.photos,
    required this.placeId,
    required this.reference,
    required this.scope,
    required this.types,
    required this.vicinity,
    required this.businessStatus,
    required this.openingHours,
    required this.plusCode,
    required this.rating,
    required this.userRatingsTotal,
    required this.priceLevel,
  });

  final Geometry? geometry;
  final String icon;
  final String iconBackgroundColor;
  final String iconMaskBaseUri;

  ///地点名称
  final String name;

  final List<Photo> photos;
  final String placeId;
  final String reference;
  final String scope;
  final List<String> types;

  ///地址
  final String vicinity;
  final String businessStatus;
  final OpeningHours? openingHours;
  final PlusCode? plusCode;
  final num rating;
  final int userRatingsTotal;
  final int priceLevel;

  ///距离当前位置(米)
  double? distance;


  factory PlaceModel.fromJson(Map<String, dynamic> json){
    return PlaceModel(
      geometry: json["geometry"] == null ? null : Geometry.fromJson(json["geometry"]),
      icon: json["icon"] ?? "",
      iconBackgroundColor: json["icon_background_color"] ?? "",
      iconMaskBaseUri: json["icon_mask_base_uri"] ?? "",
      name: json["name"] ?? "",
      photos: json["photos"] == null ? [] : List<Photo>.from(json["photos"]!.map((x) => Photo.fromJson(x))),
      placeId: json["place_id"] ?? "",
      reference: json["reference"] ?? "",
      scope: json["scope"] ?? "",
      types: json["types"] == null ? [] : List<String>.from(json["types"]!.map((x) => x)),
      vicinity: json["vicinity"] ?? "",
      businessStatus: json["business_status"] ?? "",
      openingHours: json["opening_hours"] == null ? null : OpeningHours.fromJson(json["opening_hours"]),
      plusCode: json["plus_code"] == null ? null : PlusCode.fromJson(json["plus_code"]),
      rating: json["rating"] ?? 0.0,
      userRatingsTotal: json["user_ratings_total"] ?? 0,
      priceLevel: json["price_level"] ?? 0,
    );
  }

}

class Geometry {
  Geometry({
    required this.location,
    required this.viewport,
  });

  final Location? location;
  final Viewport? viewport;

  factory Geometry.fromJson(Map<String, dynamic> json){
    return Geometry(
      location: json["location"] == null ? null : Location.fromJson(json["location"]),
      viewport: json["viewport"] == null ? null : Viewport.fromJson(json["viewport"]),
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

class Viewport {
  Viewport({
    required this.northeast,
    required this.southwest,
  });

  final Location? northeast;
  final Location? southwest;

  factory Viewport.fromJson(Map<String, dynamic> json){
    return Viewport(
      northeast: json["northeast"] == null ? null : Location.fromJson(json["northeast"]),
      southwest: json["southwest"] == null ? null : Location.fromJson(json["southwest"]),
    );
  }

}

class OpeningHours {
  OpeningHours({
    required this.openNow,
  });

  final bool openNow;

  factory OpeningHours.fromJson(Map<String, dynamic> json){
    return OpeningHours(
      openNow: json["open_now"] ?? false,
    );
  }

}

class Photo {
  Photo({
    required this.height,
    required this.htmlAttributions,
    required this.photoReference,
    required this.width,
  });

  final int height;
  final List<String> htmlAttributions;
  final String photoReference;
  final int width;

  factory Photo.fromJson(Map<String, dynamic> json){
    return Photo(
      height: json["height"] ?? 0,
      htmlAttributions: json["html_attributions"] == null ? [] : List<String>.from(json["html_attributions"]!.map((x) => x)),
      photoReference: json["photo_reference"] ?? "",
      width: json["width"] ?? 0,
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
