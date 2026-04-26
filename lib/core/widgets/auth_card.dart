import 'package:chatapp/core/utils/app_colors.dart';
import 'package:chatapp/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class AuthCard extends StatelessWidget {
  final List<Widget> children;
  final bool hasAvatar;

  const AuthCard({Key? key, required this.children, this.hasAvatar = false})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: hasAvatar ? 60 : 30,
        bottom: 30,
        left: AppStyles.horizontalPadding,
        right: AppStyles.horizontalPadding,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppStyles.cardBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}
