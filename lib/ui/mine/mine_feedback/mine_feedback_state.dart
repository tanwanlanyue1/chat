import 'dart:io';

import 'package:guanjia/generated/l10n.dart';

class MineFeedbackState {
  int typeIndex = 0;

  List<Map<String, dynamic>> typeList = [
    {
      "title": S.current.VIPSystem,
      "type": 1,
    },
    {
      "title": S.current.serviceProcess,
      "type": 2,
    },
    {
      "title": S.current.activeMarketing,
      "type": 3,
    },
    {
      "title": S.current.afterSalesService,
      "type": 4,
    },
    {
      "title": S.current.iHaveAComplaint,
      "type": 5,
    },
    {
      "title": S.current.other,
      "type": 6,
    },
  ];

  List<String> imgList = [];
}
