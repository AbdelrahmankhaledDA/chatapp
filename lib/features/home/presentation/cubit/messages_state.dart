part of 'messages_cubit.dart';

@immutable
sealed class MessagesState {}

final class MessagesInitial extends MessagesState {}

final class MessagesLoading extends MessagesState {}

final class MessagesLoaded extends MessagesState {
  List<Message> messages;
  MessagesLoaded(this.messages);
}

final class MessagesError extends MessagesState {
  String message;
  MessagesError(this.message);
}

final class SendMessageLoading extends MessagesState {}

final class SendMessageSuccess extends MessagesState {
  final String message;
  SendMessageSuccess(this.message);
}

final class SendMessageError extends MessagesState {
  final String message;
  SendMessageError(this.message);
}
