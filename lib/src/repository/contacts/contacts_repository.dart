import 'dart:convert';

import 'package:android_contacts_plugin/models/models.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class ContactsRepository {
  static const _platform =
      MethodChannel('brotherfolnciy.dev/android_contacts_plugin');

  final List<Contact> contacts = [];

  Future<List<Contact>> getContactsFromPhone() async {
    try {
      dynamic result = await _platform.invokeMethod('getContacts');

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
