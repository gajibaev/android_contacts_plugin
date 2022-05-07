import 'dart:convert';

import 'package:android_contacts_plugin/repository/contacts/models/models.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class ContactsRepository {
  static const platform =
      MethodChannel('brotherfolnciy.dev/android_contacts_plugin');

  static bool isInitialized = false;

  final List<Contact> contacts = [];

  void init() {
    if (!isInitialized) {
      isInitialized = true;
    }
  }

  Future<List<Contact>> getContactsFromPhone() async {
    try {
      dynamic result = await platform.invokeMethod('getContacts');

      Map<String, dynamic> valueMap = const JsonCodec().decode(result);
      var contacts = Response.fromJson(valueMap).contacts;

      return contacts;
    } catch (e) {
      if (e is PlatformException) {
        debugPrint(e.message);
      }
      return [];
    }
  }
}
