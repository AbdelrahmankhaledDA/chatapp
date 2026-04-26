import 'package:chatapp/core/utils/app_colors.dart';
import 'package:chatapp/core/utils/app_strings.dart';
import 'package:chatapp/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final String hint;
  final ValueChanged<String>? onChanged;

  const CustomSearchBar({
    Key? key,
    this.hint = AppStrings.placeholderSearch,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.greyCardBackground,
        borderRadius: BorderRadius.circular(AppStyles.cardBorderRadius),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        onChanged: onChanged,
        style: AppStyles.labelStyle.copyWith(color: AppColors.textPrimary),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: AppStyles.placeholderStyle,
          icon: const Icon(Icons.search, color: AppColors.textInactive),
        ),
      ),
    );
  }
}
