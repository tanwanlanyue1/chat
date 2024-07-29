
class TBLiveLineEvent{

  ///线路ID
  int id = 0;
  int matchType = 0;
  int matchId = 0;
  ///是否禁用（0否 1是）
  int isForbid = 0;

  bool get isEnabled => isForbid == 0;

  TBLiveLineEvent(this.id, this.matchType, this.matchId, this.isForbid);

  TBLiveLineEvent.fromJson(Map<String, dynamic> json)
      : id = json["id"] ?? 0,
        matchType = json["matchType"] ?? 0,
        matchId = json["matchId"] ?? 0,
        isForbid = json["isForbid"] ?? 0;

}
