import 'dart:async';

import 'package:android_contacts_plugin/repository/contacts/contacts_repository.dart';
import 'package:android_contacts_plugin/repository/contacts/models/models.dart';

class AndroidContacts {
  static final ContactsRepository contactsRepository = ContactsRepository();

  static void init() {
    contactsRepository.init();
  }

  static Future<List<Contact>> getContacts() async {
    return await contactsRepository.getContactsFromPhone();
  }
}
