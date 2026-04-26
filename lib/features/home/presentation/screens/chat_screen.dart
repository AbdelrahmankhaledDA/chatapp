import 'package:chatapp/core/DB/supabase_service.dart';
import 'package:chatapp/features/home/data/models/room_model.dart';
import 'package:chatapp/features/home/presentation/cubit/messages_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatapp/core/utils/app_colors.dart';

class ChatScreen extends StatefulWidget {
  final RoomModel? room;
  const ChatScreen({super.key, required this.room});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.room != null) {
      context.read<MessagesCubit>().getAllMessage(widget.room!.id);
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.room == null) {
      return Scaffold(body: Center(child: Text("Error: Room data is missing")));
    }
    final myid = SupabaseService().client.auth.currentUser!.id;

    return Scaffold(
      backgroundColor: AppColors.purpleLight,
      appBar: AppBar(
        backgroundColor: AppColors.purpleMain,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              backgroundImage: widget.room!.otherUserInfo?.image_profile != null
                  ? NetworkImage(widget.room!.otherUserInfo!.image_profile!)
                  : null,
              child: widget.room!.otherUserInfo?.image_profile == null
                  ? Icon(Icons.person, size: 20, color: AppColors.purpleMain)
                  : null,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.room?.otherUserInfo?.user_name ?? "User",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<MessagesCubit, MessagesState>(
              builder: (context, state) {
                if (state is MessagesLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.purpleMain,
                    ),
                  );
                }
                if (state is MessagesLoaded) {
                  return ListView.builder(
                    reverse: true,
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    physics: BouncingScrollPhysics(),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      bool ismee = state.messages[index].senderId == myid;
                      return Align(
                        alignment: ismee
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
                          decoration: BoxDecoration(
                            color: ismee ? AppColors.purpleMain : Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(15),
                              topRight: const Radius.circular(15),
                              bottomLeft: ismee
                                  ? const Radius.circular(15)
                                  : Radius.zero,
                              bottomRight: ismee
                                  ? Radius.zero
                                  : const Radius.circular(15),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            state.messages[index].content,
                            style: TextStyle(
                              color: ismee ? Colors.white : Colors.black87,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
                return const Center(child: Text("Start a conversation now! ✨"));
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, -2),
                  blurRadius: 10,
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.purpleLight,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        controller: messageController,
                        style: const TextStyle(fontSize: 16),
                        decoration: const InputDecoration(
                          hintText: "Type your message...",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  BlocBuilder<MessagesCubit, MessagesState>(
                    builder: (context, state) {
                      if (state is SendMessageLoading) {
                        return Padding(
                          padding: EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.purpleMain,
                            ),
                          ),
                        );
                      }
                      return CircleAvatar(
                        backgroundColor: AppColors.purpleMain,
                        child: IconButton(
                          onPressed: () {
                            if (messageController.text.trim().isNotEmpty) {
                              context.read<MessagesCubit>().sendMessage(
                                widget.room!.id,
                                messageController.text.trim(),
                              );
                              messageController.clear();
                            }
                          },
                          icon: const Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
