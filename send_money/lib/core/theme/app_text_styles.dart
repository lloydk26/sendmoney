import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

abstract final class AppTextStyles {
  AppTextStyles._();

  static const double headlineSize = 24;
  static const double bodySize = 16;
  static const double labelSize = 12;

  static TextStyle headline([Color? color]) => GoogleFonts.plusJakartaSans(
        fontSize: headlineSize,
        fontWeight: FontWeight.w600,
        height: 1.25,
        color: color ?? AppColors.onSurfacePrimary,
      );

  static TextStyle body([Color? color]) => GoogleFonts.plusJakartaSans(
        fontSize: bodySize,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: color ?? AppColors.onSurfacePrimary,
      );

  static TextStyle label([Color? color]) => GoogleFonts.plusJakartaSans(
        fontSize: labelSize,
        fontWeight: FontWeight.w500,
        height: 1.33,
        color: color ?? AppColors.onSurfaceSecondary,
      );
}
