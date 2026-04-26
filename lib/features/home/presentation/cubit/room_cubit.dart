import 'package:bloc/bloc.dart';
import 'package:chatapp/core/DB/supabase_service.dart';
import 'package:chatapp/features/home/data/models/room_model.dart';
import 'package:chatapp/features/home/data/repo/home_repo.dart';
import 'package:meta/meta.dart';
import 'dart:async';

part 'room_state.dart';

class RoomCubit extends Cubit<RoomState> {
  RoomCubit(this.homeRepo) : super(RoomInitial());
  HomeRepo homeRepo;

  creatRoom(myId, antherId) async {
    emit(CreateRoomLoading());

    final newRoomResult = await homeRepo.createRoom(myId, antherId);

    newRoomResult.fold((failure) => emit(CreateRoomError(failure.message)), (
      room,
    ) async {
      final userResult = await homeRepo.getUserInfo(antherId);

      userResult.fold(
        (failure) => emit(CreateRoomError("Could not fetch user info")),
        (user) {
          room.otherUserInfo = user;
          emit(CreateRoomLoaded(room));
        },
      );
    });
  }

  StreamSubscription<List<RoomModel>>? roomSubscription;

  getallRooms() {
    emit(GetAllRoomsLoading());
    try {
      roomSubscription = homeRepo.getAllRooms().listen((rooms) async {
        if (rooms.isEmpty) {
          emit(GetAllRoomsLoaded(const []));
          return;
        }

        List<RoomModel> roomsWithUsers = [];

        for (var room in rooms) {
          try {
            final otherId = room.members.firstWhere(
              (id) => id != SupabaseService().client.auth.currentUser!.id,
              orElse: () => room.members.first,
            );

            final userResult = await homeRepo.getUserInfo(otherId);
            userResult.fold(
              (failure) => print("Error fetching user: ${failure.message}"),
              (user) {
                room.otherUserInfo = user;
                roomsWithUsers.add(room);
              },
            );
          } catch (e) {
            print("Error processing room: $e");
          }
        }

        emit(GetAllRoomsLoaded(roomsWithUsers));
      });
    } catch (e) {
      emit(GetAllRoomsError(e.toString()));
    }
  }
}
