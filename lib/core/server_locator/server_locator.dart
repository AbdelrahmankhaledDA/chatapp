import 'package:chatapp/core/DB/db_service.dart';
import 'package:chatapp/core/DB/storage_service.dart';
import 'package:chatapp/core/DB/supabase_service.dart';
import 'package:chatapp/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:chatapp/features/auth/repo/auth_repo.dart';
import 'package:chatapp/features/contacts/data/repo/contacts_repo.dart';
import 'package:chatapp/features/contacts/presentation/cubit/contacts_cubit.dart';
import 'package:chatapp/features/home/data/repo/home_repo.dart';
import 'package:chatapp/features/home/presentation/cubit/messages_cubit.dart';
import 'package:chatapp/features/home/presentation/cubit/room_cubit.dart';
import 'package:chatapp/features/profile/cubit/profile_cubit.dart';
import 'package:chatapp/features/profile/repo/profile_repo.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

GetIt locator = GetIt.instance;
void setupLocator() {
  final supabaseClient = Supabase.instance.client;
  locator.registerSingleton<DbService>(SupabaseService());
  locator.registerLazySingleton<SupabaseClient>(() => supabaseClient);
  locator.registerLazySingleton<StorageService>(
    () => StorageService(supabaseClient),
  );
  // repos are  singletons
  locator.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(
      locator<DbService>(),
      supabaseClient,
      locator<StorageService>(),
    ),
  );
  locator.registerSingleton<ContactsRepo>(
    ContactsRepoImpl(locator.get<DbService>()),
  );
  locator.registerSingleton<ProfileRepo>(
    ProfileRepoImpl(locator.get<DbService>(), locator.get<StorageService>()),
  );
  locator.registerSingleton<HomeRepo>(HomeRepo(locator.get<DbService>()));

  // cubits are  factories
  locator.registerFactory<AuthCubit>(() => AuthCubit(locator.get<AuthRepo>()));
  locator.registerFactory<ContactsCubit>(
    () => ContactsCubit(locator.get<ContactsRepo>()),
  );
  locator.registerFactory<ProfileCubit>(
    () => ProfileCubit(locator.get<ProfileRepo>()),
  );
  locator.registerFactory<RoomCubit>(() => RoomCubit(locator.get<HomeRepo>()));
  locator.registerFactory<MessagesCubit>(
    () => MessagesCubit(locator.get<HomeRepo>()),
  );
}
