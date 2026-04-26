import 'package:chatapp/core/utils/app_colors.dart';
import 'package:chatapp/core/utils/app_strings.dart';
import 'package:chatapp/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class SmallAddButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const SmallAddButton({
    Key? key,
    required this.onPressed,
    this.text = AppStrings.btnAdd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.purpleButton),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: AppStyles.buttonTextStyle.copyWith(
            color: AppColors.purpleButton,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
