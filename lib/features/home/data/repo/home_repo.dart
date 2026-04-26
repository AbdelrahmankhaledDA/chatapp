import 'package:chatapp/core/DB/DB_failuires.dart';
import 'package:chatapp/core/DB/db_service.dart';
import 'package:chatapp/core/DB/supabase_service.dart';
import 'package:chatapp/features/auth/models/user_info_model.dart';
import 'package:chatapp/features/home/data/models/message.dart';
import 'package:chatapp/features/home/data/models/room_model.dart';
import 'package:dartz/dartz.dart';

class HomeRepo {
  DbService dbService;
  HomeRepo(this.dbService);
  SupabaseService supabaseService = SupabaseService();
  Future<Either<Failure, UserInfoModel>> getUserInfo(userid) async {
    try {
      final row = await dbService.getUserData("userInfo", "UID", userid);
      final user = UserInfoModel.fromJson(row);
      print("users ${user.UID}");
      return Right(user);
    } catch (e) {
      return Left(DbFailure("the error is $e"));
    }
  }

  Future<Either<Failure, RoomModel>> createRoom(
    String myId,
    String antherId,
  ) async {
    final sortId = [myId, antherId]..sort();
    final idRoom = '${sortId[0]}-${sortId[1]}';

    RoomModel room = RoomModel(
      id: idRoom,
      lastMessage: "",
      unreadMessages: 0,
      members: sortId,
    );
    try {
      await supabaseService.client
          .from("rooms")
          .upsert(room.toJson(), onConflict: 'id');
      return Right(room);
    } catch (e) {
      return Left(DbFailure("The error is $e"));
    }
  }

  Stream<List<RoomModel>> getAllRooms() {
    try {
      final myid = supabaseService.client.auth.currentUser!.id;
      final stream = supabaseService.client
          .from("rooms")
          .stream(primaryKey: ['id']);

      final allRooms = stream.map((e) {
        return e
            .map((e) => RoomModel.fromJson(e))
            .where((room) => room.members.contains(myid))
            .toList();
      });
      print("allRooms $allRooms");

      return allRooms;
    } catch (e) {
      throw Exception("the error is $e");
    }
  }

  Future<void> sendMessage(roomId, content) async {
    final myid = supabaseService.client.auth.currentUser!.id;

    Message message = Message(
      roomId: roomId,
      senderId: myid,
      content: content,
      createdAt: DateTime.now(),
    );
    try {
      await dbService.insert("messages", message.toJson());

      print("message sent");

      await dbService.upadte("rooms", {"lastMessage": content}, "id", roomId);
    } catch (e) {
      throw Exception("the error is $e");
    }
  }

  Stream<List<Message>> getAllMessages(roomId) {
    try {
      final stream = supabaseService.client
          .from("messages")
          .stream(primaryKey: ['id'])
          .eq('roomId', roomId)
          .order('createdAt', ascending: false);

      return stream.map((e) => e.map((e) => Message.fromJson(e)).toList());
    } catch (e) {
      throw Exception("the error is $e");
    }
  }
}
