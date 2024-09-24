import 'package:flutter/material.dart';
import 'package:guanjia/generated/l10n.dart';

import 'footer_tile.dart';

class NewPageErrorIndicator extends StatelessWidget {
  const NewPageErrorIndicator({
    Key? key,
    this.onTap,
  }) : super(key: key);
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: FooterTile(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                S.current.retryWithLoadFail,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 4,
              ),
              const Icon(
                Icons.refresh,
                size: 16,
              ),
            ],
          ),
        ),
      );
}
