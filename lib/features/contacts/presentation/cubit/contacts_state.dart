part of 'contacts_cubit.dart';

@immutable
sealed class ContactsState {}

final class ContactsInitial extends ContactsState {}

final class ContactsLoading extends ContactsState {}

final class ContactsSuccess extends ContactsState {
  final List<UserInfoModel> contacts;
  ContactsSuccess(this.contacts);
}

final class ContactsError extends ContactsState {
  final String error;
  ContactsError(this.error);
}
