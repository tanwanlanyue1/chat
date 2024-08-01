import 'dart:io';

import 'package:guanjia/generated/l10n.dart';

class MineFeedbackState {
  int typeIndex = 0;

  List<Map<String, dynamic>> typeList = [
    {
      "title": S.current.VIPSystem,
      "type": 0,
    },
    {
      "title": S.current.serviceProcess,
      "type": 1,
    },
    {
      "title": S.current.activeMarketing,
      "type": 2,
    },
    {
      "title": S.current.afterSalesService,
      "type": 3,
    },
    {
      "title": S.current.iHaveAComplaint,
      "type": 4,
    },
    {
      "title": S.current.other,
      "type": 999,
    },
  ];

  List<File> imgList = [];
}
