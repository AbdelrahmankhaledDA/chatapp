import 'package:chatapp/core/utils/app_colors.dart';
import 'package:chatapp/core/utils/app_styles.dart';
import 'package:chatapp/core/widgets/buttons/small_add_button.dart';
import 'package:chatapp/features/auth/models/user_info_model.dart';
import 'package:flutter/material.dart';

class AddContactItem extends StatelessWidget {
  final UserInfoModel contact;
  final VoidCallback onAddPressed;

  const AddContactItem({
    Key? key,
    required this.contact,
    required this.onAddPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: contact.image_profile != null
                  ? NetworkImage(contact.image_profile!)
                  : null,
              backgroundColor: AppColors.greyCardBackground,
              child: contact.image_profile == null
                  ? Icon(Icons.person, color: AppColors.textInactive)
                  : null,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.user_name,
                    style: AppStyles.titleStyle.copyWith(fontSize: 16),
                  ),
                  Text(
                    contact.phone_num,
                    style: AppStyles.subtitleStyle.copyWith(
                      color: AppColors.textActive,
                    ),
                  ),
                ],
              ),
            ),
            SmallAddButton(onPressed: onAddPressed),
          ],
        ),
        const SizedBox(height: 10),
        const Divider(color: AppColors.purpleLight),
      ],
    );
  }
}
