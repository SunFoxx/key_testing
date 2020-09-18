import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:key_testing/theme/colors.dart';

class AppTextStyles {
  static final TextStyle primaryFont = GoogleFonts.comfortaa();

  static final TextStyle secondaryFont = GoogleFonts.openSans();

  static TextStyle get logoStyle => primaryFont.copyWith(
        color: CupertinoColors.white,
        fontWeight: FontWeight.w900,
        fontSize: 32.0,
        letterSpacing: 0.5,
      );

  static TextStyle get inputLabelStyle => primaryFont.copyWith(
        color: AppColors.primary55,
        fontWeight: FontWeight.w500,
        fontSize: 14.0,
      );

  static TextStyle get inputTextStyle => primaryFont.copyWith(
        color: AppColors.primary,
        fontWeight: FontWeight.w500,
        fontSize: 16.0,
      );

  static TextStyle get focusedTextStyle => secondaryFont.copyWith(
        color: AppColors.focus,
        fontWeight: FontWeight.w500,
        fontSize: 16.0,
      );

  static TextStyle get buttonTextStyle => primaryFont.copyWith(
        color: AppColors.background,
        fontWeight: FontWeight.w600,
        fontSize: 18.0,
        letterSpacing: 1.0,
      );
}
