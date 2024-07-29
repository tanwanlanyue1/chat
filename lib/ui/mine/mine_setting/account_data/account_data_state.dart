class AccountDataState {
  String getGenderString(int? gender) {
    switch (gender) {
      case 0:
        return "保密";
      case 1:
        return "男";
      case 2:
        return "女";
      default:
        return "请选择性别";
    }
  }
}
