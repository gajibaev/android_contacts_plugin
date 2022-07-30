import 'dart:convert';

import 'package:android_contacts_plugin/models/models.dart';
import 'package:flutter/services.dart';

class ContactsRepository {
  static const _platform =
      MethodChannel('brotherfolnciy.dev/android_contacts_plugin');

  Future<List<Contact>> getContactsFromPhone() async {
    try {
      dynamic result = await _platform.invokeMethod('getContacts');

      Map<String, dynamic> valueMap = const JsonCodec().decode(result);
      var contacts = Response.fromJson(valueMap).contacts;

      return contacts;
    } catch (e) {
      return [];
    }
  }
}
