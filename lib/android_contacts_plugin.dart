import 'dart:async';

import 'package:android_contacts_plugin/models/models.dart';
import 'package:android_contacts_plugin/src/repository/contacts/contacts_repository.dart';

class AndroidContacts {
  static final ContactsRepository _contactsRepository = ContactsRepository();

  static bool initialized = false;

  static Future<List<Contact>> getContacts() async {
    return await _contactsRepository.getContactsFromPhone();
  }
}


// TODO Отрефакторить код на kotlin
// TODO Отрефакторить код на примере 
// TODO Задокументировать использование пакета и выходные данные
// TODO Сделать 2 скриншота работы программы и выложить в Git Hub