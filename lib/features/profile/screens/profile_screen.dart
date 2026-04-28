import 'dart:typed_data';
import 'package:chatapp/core/DB/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import 'package:chatapp/core/routing/router_config.dart';
import 'package:chatapp/core/utils/app_strings.dart';
import 'package:chatapp/core/utils/app_colors.dart';
import 'package:chatapp/core/utils/app_styles.dart';
import 'package:chatapp/core/widgets/forms/custom_text_field.dart';
import 'package:chatapp/core/widgets/buttons/app_button.dart';
import 'package:chatapp/features/auth/models/user_info_model.dart';
import 'package:chatapp/features/profile/cubit/profile_cubit.dart';

class ProfileScreen extends StatefulWidget {
  final UserInfoModel user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Uint8List? updatedImageBytes;
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;

  UserInfoModel? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = widget.user;
    nameController = TextEditingController(text: currentUser!.user_name);
    phoneController = TextEditingController(text: currentUser!.phone_num);
    emailController = TextEditingController(text: currentUser!.email);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileCubit>().getProfileData();
    });
  }

  Future<void> pickNewImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        updatedImageBytes = bytes;
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.purpleLight,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              context.push(RouterConfigGenerator.contacts);
            },
            icon: Icon(Icons.contacts, color: Colors.white),
          ),
        ],
        title: Text(AppStrings.profile, style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.purpleMain,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
          if (state is ProfileUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            setState(() {
              updatedImageBytes = null;
            });
            context.read<ProfileCubit>().getProfileData();
          }
          if (state is ProfileSuccess) {
            // تحديث المتغير المحلي والحقول بالبيانات الجديدة من قاعدة البيانات
            setState(() {
              currentUser = state.userInfo;
              nameController.text = currentUser!.user_name;
              phoneController.text = currentUser!.phone_num;
              emailController.text = currentUser!.email;
            });
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.purpleMain,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(40),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 50,
                      child: GestureDetector(
                        onTap: pickNewImage,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 4,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 65,
                                backgroundColor: Colors.grey[200],
                                backgroundImage: updatedImageBytes != null
                                    ? MemoryImage(updatedImageBytes!)
                                    : (currentUser?.image_profile != null
                                              ? NetworkImage(
                                                  "${currentUser!.image_profile!}?v=${DateTime.now().millisecondsSinceEpoch}",
                                                )
                                              : null)
                                          as ImageProvider?,
                                child:
                                    (updatedImageBytes == null &&
                                        currentUser?.image_profile == null)
                                    ? Icon(
                                        Icons.person,
                                        size: 60,
                                        color: Colors.grey,
                                      )
                                    : null,
                              ),
                            ),
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: AppColors.purpleMain,
                              child: Icon(
                                Icons.camera_alt,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 60),

                if (state is ProfileLoading || state is ProfileUpdating)
                  CircularProgressIndicator(color: AppColors.purpleMain)
                else
                  Text(
                    currentUser?.user_name ?? "",
                    style: AppStyles.subtitleStyle.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                SizedBox(height: 20),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: emailController,
                        label: AppStrings.labelEmail,
                        hint: AppStrings.placeholderEmail,
                        icon: Icons.email_outlined,
                        readOnly: true,
                         enabled: false,
                      ),
                      SizedBox(height: 10),
                      CustomTextField(
                        controller: nameController,
                        label: AppStrings.labelFullName,
                        hint: AppStrings.placeholderName,
                        icon: Icons.person_outline,
                      ),
                      SizedBox(height: 10),
                      CustomTextField(
                        controller: phoneController,
                        label: AppStrings.labelPhone,
                        hint: AppStrings.placeholderPhone,
                        icon: Icons.phone_outlined,
                      ),
                      SizedBox(height: 25),

                      AppButton(
                        text: AppStrings.update_Profile,
                        icon: Icons.update,
                        onPressed: () {
                          context.read<ProfileCubit>().updateProfileData(
                            nameController.text,
                            phoneController.text,
                            updatedImageBytes,
                          );
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 40),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: AppButton(
                    text: AppStrings.logout,
                    icon: Icons.logout,
                    onPressed: () async {
                      await SupabaseService().signOut();
                      if (context.mounted) {
                        context.go(RouterConfigGenerator.signIn);
                      }
                    },
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }
}
