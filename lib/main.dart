import 'package:chatapp/core/server_locator/server_locator.dart';
import 'package:chatapp/features/auth/presentation/screens/login_screen.dart';
import 'package:chatapp/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:chatapp/features/contacts/presentation/cubit/contacts_cubit.dart';
import 'package:chatapp/features/contacts/presentation/screens/contacts_screen.dart';
import 'package:chatapp/features/home/presentation/cubit/messages_cubit.dart';
import 'package:chatapp/features/home/presentation/cubit/room_cubit.dart';
import 'package:chatapp/features/profile/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:chatapp/core/routing/router_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://lnlqowbvivlgmcryviuf.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxubHFvd2J2aXZsZ21jcnl2aXVmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzY4OTMzNTEsImV4cCI6MjA5MjQ2OTM1MX0.unJfjrhXcZISvCxVLCBml-kGvcGnB3zhCFg_7F4iQ5w",
  );
  setupLocator();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => locator<ContactsCubit>()),

        BlocProvider(create: (context) => locator<ProfileCubit>()),
        BlocProvider(create: (context) => locator<RoomCubit>()..getallRooms()),
        BlocProvider(create: (context) => locator<MessagesCubit>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: RouterConfigGenerator.goRouter,
      title: 'PWA Chat App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
    );
  }
}
