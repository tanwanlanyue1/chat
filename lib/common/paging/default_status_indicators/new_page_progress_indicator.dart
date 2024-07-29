import 'package:flutter/cupertino.dart';

import 'footer_tile.dart';

class NewPageProgressIndicator extends StatelessWidget {
  const NewPageProgressIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) => const FooterTile(
        child: CupertinoActivityIndicator(),
      );
}
