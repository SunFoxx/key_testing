import 'dart:ui';

import 'package:flutter/cupertino.dart';

class AppColors {
  static Color get transparent => Color(0x00ffffff);
  static Color get primary => Color(0xff1D1D1D);
  static Color get primary55 => primary.withOpacity(0.75);
  static Color get primary05 => Color(0xffF9F9F9);
  static Color get error => CupertinoColors.systemRed;

  static Color get focus => CupertinoColors.activeBlue;
  static Color get background => CupertinoColors.white;
}
