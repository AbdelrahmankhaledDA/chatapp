import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chatapp/features/home/data/models/message.dart';
import 'package:chatapp/features/home/data/repo/home_repo.dart';
import 'package:meta/meta.dart';

part 'messages_state.dart';

class MessagesCubit extends Cubit<MessagesState> {
  MessagesCubit(this.repo) : super(MessagesInitial());
  HomeRepo repo;
  sendMessage(roomId, content) async {
    emit(SendMessageLoading());
    try {
      await repo.sendMessage(roomId, content);
      emit(SendMessageSuccess(" send Message succ "));
      getAllMessage(roomId);
    } catch (e) {
      emit(SendMessageError(e.toString()));
    }
  }

  StreamSubscription<List<Message>>? streamSubscription;

  getAllMessage(roomId) {
    emit(MessagesLoading());
    try {
      streamSubscription = repo.getAllMessages(roomId).listen((messages) {
        emit(MessagesLoaded(messages));
      });
    } catch (e) {
      emit(MessagesError(e.toString()));
    }
  }
}
