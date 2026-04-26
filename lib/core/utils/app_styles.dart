import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppStyles {
  AppStyles._();

  static const TextStyle headerStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textInactive,
  );

  static const TextStyle labelStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textActive,
  );

  static const TextStyle placeholderStyle = TextStyle(
    fontSize: 14,
    color: AppColors.textInactive,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static const TextStyle messageSenderStyle = TextStyle(
    fontSize: 14,
    color: AppColors.white,
  );

  static const TextStyle messageRecipientStyle = TextStyle(
    fontSize: 14,
    color: AppColors.textPrimary,
  );

  static const double horizontalPadding = 20.0;
  static const double cardBorderRadius = 30.0;
  static const double buttonBorderRadius = 15.0;
}
