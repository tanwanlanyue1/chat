import 'package:flutter/material.dart';

///钱包记录
class WalletRecordView extends StatefulWidget {
  const WalletRecordView({super.key});

  @override
  State<WalletRecordView> createState() => _WalletRecordViewState();
}

class _WalletRecordViewState extends State<WalletRecordView> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const Placeholder();
  }

  @override
  bool get wantKeepAlive => true;
}
