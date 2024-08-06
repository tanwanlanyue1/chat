enum WalletOperationType {
  normal, // 普通
  topUp, // 充值
  transfer, // 转账
  withdrawal, // 提现
  record; // 记录

  static WalletOperationType valueForIndex(int index) {
    return WalletOperationType.values.elementAtOrNull(index) ??
        WalletOperationType.normal;
  }
}
