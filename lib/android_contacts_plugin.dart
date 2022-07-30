import 'dart:async';

import 'package:android_contacts_plugin/models/models.dart';
import 'package:android_contacts_plugin/src/repository/contacts/contacts_repository.dart';

class AndroidContacts {
  static final ContactsRepository _contactsRepository = ContactsRepository();

  static Future<List<Contact>> getContacts() async {
    return await _contactsRepository.getContactsFromPhone();
  }
}
