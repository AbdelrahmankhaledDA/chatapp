import 'package:chatapp/core/utils/app_colors.dart';
import 'package:chatapp/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData? icon;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final bool? readOnly;
  final bool? enabled;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.hint,
    this.icon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.readOnly,
    this.enabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppStyles.labelStyle),
        const SizedBox(height: 5),
        TextField(
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: AppStyles.labelStyle.copyWith(color: AppColors.textPrimary),
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppStyles.placeholderStyle,
            prefixIcon: icon != null
                ? Icon(icon, color: AppColors.textInactive)
                : null,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 18,
              horizontal: 20,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: AppColors.textInactive),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: AppColors.purpleButton,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
