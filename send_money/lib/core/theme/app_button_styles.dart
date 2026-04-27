import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

abstract final class AppButtonStyles {
  AppButtonStyles._();

  static const double _radius = 12;

  static RoundedRectangleBorder _shape([double radius = _radius]) =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));

  /// Alias for [primaryFilled] (design-system naming).
  static ButtonStyle primary() => primaryFilled();

  static ButtonStyle primaryFilled() {
    return FilledButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onAccentFill,
      disabledBackgroundColor: AppColors.primaryDark3.withValues(alpha: 0.5),
      disabledForegroundColor: AppColors.onAccentFill.withValues(alpha: 0.38),
      textStyle: AppTextStyles.label(AppColors.onAccentFill).copyWith(
        fontWeight: FontWeight.w600,
        fontSize: AppTextStyles.bodySize,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: _shape(),
    );
  }

  static ButtonStyle secondaryFilled() {
    return FilledButton.styleFrom(
      backgroundColor: AppColors.secondary,
      foregroundColor: AppColors.onAccentFill,
      disabledBackgroundColor: AppColors.secondaryDark3.withValues(alpha: 0.5),
      disabledForegroundColor: AppColors.onAccentFill.withValues(alpha: 0.38),
      textStyle: AppTextStyles.label(AppColors.onAccentFill).copyWith(
        fontWeight: FontWeight.w600,
        fontSize: AppTextStyles.bodySize,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: _shape(),
    );
  }

  static ButtonStyle inverted() {
    return OutlinedButton.styleFrom(
      backgroundColor: AppColors.neutralDark1,
      foregroundColor: AppColors.onSurfacePrimary,
      side: const BorderSide(color: AppColors.tertiaryDark1, width: 1.5),
      textStyle: AppTextStyles.body(AppColors.onSurfacePrimary).copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 15,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: _shape(),
    );
  }

  static ButtonStyle outlined() {
    return OutlinedButton.styleFrom(
      foregroundColor: AppColors.primary,
      side: const BorderSide(color: AppColors.primary, width: 1.5),
      backgroundColor: Colors.transparent,
      textStyle: AppTextStyles.label(AppColors.primary).copyWith(
        fontWeight: FontWeight.w600,
        fontSize: AppTextStyles.bodySize,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: _shape(),
    );
  }
}
