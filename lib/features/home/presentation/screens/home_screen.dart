import 'package:chatapp/core/DB/supabase_service.dart';
import 'package:chatapp/features/auth/models/user_info_model.dart';
import 'package:chatapp/features/home/presentation/cubit/room_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:chatapp/core/utils/app_colors.dart';
import 'package:chatapp/core/utils/app_styles.dart';
import 'package:chatapp/core/routing/router_config.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  void initState() {
    super.initState();
    context.read<RoomCubit>().getallRooms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.purpleLight,
      appBar: AppBar(
        title: Text(
          "Home",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.purpleMain,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        leading: IconButton(
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
          icon: const Icon(Icons.person_outline, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await SupabaseService().signOut();
              context.go(RouterConfigGenerator.signIn);
            },
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
          ),
        ],
      ),
      body: BlocBuilder<RoomCubit, RoomState>(
        builder: (context, state) {
          if (state is GetAllRoomsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.purpleMain),
            );
          }
          if (state is GetAllRoomsLoaded) {
            if (state.rooms.isEmpty) {
              return Center(
                child: Text(
                  "No conversations yet",
                  style: AppStyles.subtitleStyle,
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              itemCount: state.rooms.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final room = state.rooms[index];
                return ListTile(
                  onTap: () {
                    context.push(RouterConfigGenerator.chat, extra: room);
                  },
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.purpleLight,
                    backgroundImage: room.otherUserInfo?.image_profile != null
                        ? NetworkImage("${room.otherUserInfo?.image_profile}")
                        : null,
                    child: room.otherUserInfo?.image_profile == null
                        ? const Icon(Icons.person, color: AppColors.purpleMain)
                        : null,
                  ),
                  title: Text(
                    "${room.otherUserInfo?.user_name}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    "${room.lastMessage}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (room.unreadMessages != null &&
                          room.unreadMessages! > 0)
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.purpleMain,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            "${room.unreadMessages}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      const SizedBox(height: 5),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                );
              },
            );
          }
          if (state is GetAllRoomsError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(RouterConfigGenerator.contacts);
        },
        backgroundColor: AppColors.purpleMain,
        elevation: 4,
        child: const Icon(Icons.add_comment_rounded, color: Colors.white),
      ),
    );
  }
}
