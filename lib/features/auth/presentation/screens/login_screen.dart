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

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<AuthCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.purpleLight,
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              final userName = state.userModel?.user_name ?? "User";
              final String w = AppStrings.welcome;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('$w , $userName!')));
              context.push(
                RouterConfigGenerator.profile,
                extra: state.userModel,
              );
            }
            if (state is AuthError) {
              final String e = AppStrings.an_Error_occured;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('$e. : ${state.message}')));
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is AuthError) {
              return Center(child: Text(state.message));
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 250,
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 80, bottom: 40),
                    decoration: BoxDecoration(
                      color: AppColors.purpleMain,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(AppStyles.cardBorderRadius),
                      ),
                    ),
                    child: Center(
                      child: Hero(
                        tag: 'logo',
                        child: Text(
                          AppStrings.appTitleLogin,
                          style: AppStyles.headerStyle.copyWith(
                            color: AppColors.white,
                            fontSize: 60,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  AuthCard(
                    children: [
                      Text(AppStrings.textLogin, style: AppStyles.titleStyle),
                      SizedBox(height: 20),
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
                          text: AppStrings.btnNextStep,
                          icon: Icons.double_arrow_rounded,
                          onPressed: () {
                            context.read<AuthCubit>().logIn(
                              emailController.text,
                              passController.text,
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.textNoAccount,
                            style: AppStyles.subtitleStyle,
                          ),
                          TextButton(
                            onPressed: () {
                              context.push(RouterConfigGenerator.signIn);
                            },
                            child: Text(
                              AppStrings.linkSignIn,
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
            );
          },
        ),
      ),
    );
  }
}
