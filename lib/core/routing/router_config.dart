import 'package:chatapp/core/server_locator/server_locator.dart';
import 'package:chatapp/features/auth/models/user_info_model.dart';
import 'package:chatapp/features/auth/presentation/screens/login_screen.dart';
import 'package:chatapp/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:chatapp/features/contacts/presentation/cubit/contacts_cubit.dart';
import 'package:chatapp/features/contacts/presentation/screens/contacts_screen.dart';
import 'package:chatapp/features/home/data/models/room_model.dart';
import 'package:chatapp/features/home/presentation/screens/chat_screen.dart';
import 'package:chatapp/features/home/presentation/screens/home_screen.dart';
import 'package:chatapp/features/profile/screens/profile_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RouterConfigGenerator {
  static const String home = '/home';
  static const String profile = '/profile';
  static const String contacts = '/contacts';
  static const String chat = '/chat';
  static const String login = '/login';
  static const String signIn = '/signIn';
  static GoRouter goRouter = GoRouter(
    initialLocation: signIn,
    routes: [
      GoRoute(
        path: contacts,
        builder: (context, state) {
          return BlocProvider(
            create: (context) => locator<ContactsCubit>()..fechContacts(),
            child: const ContactsScreen(),
          );
        },
      ),
      GoRoute(
        path: profile,
        builder: (context, state) {
          final user = state.extra as UserInfoModel;
          return ProfileScreen(user: user);
        },
      ),
      GoRoute(
        path: chat,
        builder: (context, state) {
          final room = state.extra as RoomModel;
          return ChatScreen(room: room);
        },
      ),
      GoRoute(
        path: login,
        builder: (context, state) {
          return LoginScreen();
        },
      ),
      GoRoute(
        path: home,
        builder: (context, state) {
          return Homescreen();
        },
      ),
      GoRoute(
        path: signIn,
        builder: (context, state) {
          return SignInScreen();
        },
      ),
    ],
  );
}
