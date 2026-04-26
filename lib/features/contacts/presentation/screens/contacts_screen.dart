import 'package:chatapp/core/DB/supabase_service.dart';
import 'package:chatapp/core/routing/router_config.dart';
import 'package:chatapp/core/utils/app_strings.dart';
import 'package:chatapp/features/auth/models/user_info_model.dart';
import 'package:chatapp/features/contacts/presentation/cubit/contacts_cubit.dart';
import 'package:chatapp/features/home/data/models/room_model.dart';

import 'package:chatapp/features/home/presentation/cubit/room_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:chatapp/core/utils/app_colors.dart';
import 'package:chatapp/core/utils/app_styles.dart';
import 'package:go_router/go_router.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.purpleLight,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white),
            onPressed: () {
              context.push(RouterConfigGenerator.home);
            },
          ),
          IconButton(
            onPressed: () {
              context.push(
                RouterConfigGenerator.profile,
                extra: UserInfoModel(
                  UID: SupabaseService().client.auth.currentUser!.id,
                  user_name: '',
                  email: '',
                  phone_num: '',
                ),
              );
            },
            icon: const Icon(Icons.person, color: Colors.white),
          ),
        ],
        backgroundColor: AppColors.purpleMain,
        elevation: 0,
        title: Text(
          AppStrings.my_Contacts,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: BlocBuilder<ContactsCubit, ContactsState>(
        builder: (context, state) {
          if (state is ContactsInitial) {
            context.read<ContactsCubit>().fechContacts();
            return Center(child: CircularProgressIndicator());
          }
          if (state is ContactsLoading) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.purpleMain),
            );
          }
          if (state is ContactsError) {
            return Center(
              child: Text(state.error, style: TextStyle(color: Colors.red)),
            );
          }
          if (state is ContactsSuccess) {
            return BlocListener<RoomCubit, RoomState>(
              listener: (context, state) {
                if (state is CreateRoomLoaded) {
                  context.push(RouterConfigGenerator.chat, extra: state.room);
                }
                if (state is CreateRoomError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                itemCount: state.contacts.length,
                itemBuilder: (context, index) {
                  final contact = state.contacts[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),
                      onTap: () {
                        final userId =
                            SupabaseService().client.auth.currentUser!.id;

                        context.read<RoomCubit>().creatRoom(
                          userId,
                          state.contacts[index].UID,
                        );

                        //context.push(RouterConfigGenerator.chat);
                      },
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: AppColors.purpleMain.withOpacity(0.2),
                        backgroundImage: contact.image_profile != null
                            ? NetworkImage(contact.image_profile!)
                            : null,
                        child: contact.image_profile == null
                            ? Text(
                                contact.user_name[0].toUpperCase(),
                                style: const TextStyle(
                                  color: AppColors.purpleMain,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                      ),
                      title: Text(
                        contact.user_name,
                        style: AppStyles.subtitleStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        contact.email,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                      trailing: Text(
                        contact.phone_num,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
