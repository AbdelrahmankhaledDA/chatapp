import 'package:bloc/bloc.dart';
import 'package:chatapp/features/auth/models/user_info_model.dart';
import 'package:chatapp/features/contacts/data/repo/contacts_repo.dart';
import 'package:meta/meta.dart';

part 'contacts_state.dart';

class ContactsCubit extends Cubit<ContactsState> {
  ContactsCubit(this.contactsRepo) : super(ContactsInitial());
  ContactsRepo contactsRepo;
  Future<void> fechContacts() async {
    emit(ContactsLoading());
    final result = await contactsRepo.getAllContacts();
    result.fold(
      (l) => emit(ContactsError(l.message)),
      (r) => emit(ContactsSuccess(r)),
    );
  }
}
