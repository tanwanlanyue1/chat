enum WalletOperationType {
  recharge, // 充值
  withdrawal, // 提现
  record; // 记录

  static WalletOperationType valueForIndex(int index) {
    return WalletOperationType.values.elementAtOrNull(index) ??
        WalletOperationType.record;
  }
}
