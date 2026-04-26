import 'dart:typed_data';

import 'package:chatapp/core/routing/router_config.dart';
import 'package:chatapp/core/server_locator/server_locator.dart';
import 'package:chatapp/core/utils/app_colors.dart';
import 'package:chatapp/core/utils/app_strings.dart';
import 'package:chatapp/core/utils/app_styles.dart';
import 'package:chatapp/core/widgets/auth_card.dart';
import 'package:chatapp/core/widgets/buttons/app_button.dart';
import 'package:chatapp/core/widgets/forms/custom_text_field.dart';
import 'package:chatapp/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  Uint8List? selectedImage;

  Future<void> pickProfileImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        selectedImage = bytes;
      });
    }
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  initState() {
    super.initState();
    emailController.text;
    passController.text;
    phoneController.text;
    usernameController.text;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<AuthCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.purpleLight,
        body: BlocConsumer<AuthCubit, AuthState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.purpleMain,
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(AppStyles.cardBorderRadius),
                          ),
                        ),
                      ),
                      SizedBox(height: 60),

                      AuthCard(
                        hasAvatar: true,
                        children: [
                          CustomTextField(
                            controller: usernameController,
                            label: AppStrings.labelFullName,
                            hint: AppStrings.placeholderName,
                            icon: Icons.person,
                          ),
                          SizedBox(height: 15),
                          CustomTextField(
                            controller: phoneController,
                            label: AppStrings.labelPhone,
                            hint: AppStrings.placeholderPhone,
                            icon: Icons.phone,
                          ),
                          SizedBox(height: 15),
                          CustomTextField(
                            controller: emailController,
                            label: AppStrings.labelEmail,
                            hint: AppStrings.placeholderEmail,
                            icon: Icons.email_outlined,
                          ),
                          SizedBox(height: 15),
                          CustomTextField(
                            controller: passController,
                            label: AppStrings.labelPassword,
                            hint: AppStrings.placeholderPassword,
                            icon: Icons.password_outlined,
                            obscureText: true,
                          ),
                          SizedBox(height: 25),
                          Center(
                            child: AppButton(
                              text: AppStrings.btnCreateAcc,
                              icon: Icons.double_arrow_rounded,
                              onPressed: () async {
                                await context.read<AuthCubit>().register(
                                  emailController.text,
                                  passController.text,
                                  phoneController.text,
                                  usernameController.text,
                                  selectedImage,
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppStrings.textHaveAccount,
                                style: AppStyles.subtitleStyle,
                              ),
                              TextButton(
                                onPressed: () {
                                  context.push(RouterConfigGenerator.login);
                                },
                                child: Text(
                                  AppStrings.linkLogin,
                                  style: AppStyles.subtitleStyle.copyWith(
                                    color: AppColors.purpleMain,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 50),
                    ],
                  ),
                  Positioned(
                    top: 130,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: GestureDetector(
                        onTap: pickProfileImage,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: selectedImage != null
                                ? MemoryImage(selectedImage!)
                                : null,
                            child: selectedImage == null
                                ? const Icon(
                                    Icons.add_a_photo,
                                    size: 30,
                                    color: AppColors.purpleMain,
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          listener: (BuildContext context, AuthState state) {
            if (state is AuthSuccess) {
              final String w = AppStrings.welcome;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$w , ${state.userModel.user_name}!')),
              );
              print("User Name: ${state.userModel.user_name}");
              context.push(
                RouterConfigGenerator.profile,
                extra: state.userModel,
              );
            }
            if (state is AuthError) {
              final String e = AppStrings.an_Error_occured;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('$e : ${state.message}')));
            }
          },
        ),
      ),
    );
  }
}
