import 'package:flutter/material.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

import 'wallet_recharge_view.dart';

///充值
class WalletRechargePage extends StatefulWidget {
  const WalletRechargePage({super.key});

  @override
  State<WalletRechargePage> createState() => _WalletRechargePageState();
}

class _WalletRechargePageState extends State<WalletRechargePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.current.topUp)),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: AppImage.asset(
              'assets/images/wallet/recharge_bg.jpg',
              fit: BoxFit.cover,
            ),
          ),
          const WalletRechargeView(fromRechargePage: true),
        ],
      ),
    );
  }
}
