part of 'room_cubit.dart';

@immutable
sealed class RoomState {}

final class RoomInitial extends RoomState {}

final class CreateRoomLoading extends RoomState {}

final class CreateRoomLoaded extends RoomState {
  final RoomModel room;
  CreateRoomLoaded(this.room);
}

final class CreateRoomError extends RoomState {
  final String message;
  CreateRoomError(this.message);
}

final class GetAllRoomsLoading extends RoomState {}

final class GetAllRoomsLoaded extends RoomState {
  final List<RoomModel> rooms;
  GetAllRoomsLoaded(this.rooms);
}

final class GetAllRoomsError extends RoomState {
  final String message;
  GetAllRoomsError(this.message);
}
