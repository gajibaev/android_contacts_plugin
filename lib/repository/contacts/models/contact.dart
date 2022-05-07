import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contact.g.dart';

@JsonSerializable()
class Contact {
  final String? name;
  final List<String> phones;
  final String? imageBase64;

  Contact(
      {required this.name, required this.phones, required this.imageBase64});

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);

  Map<String, dynamic> toJson() => _$ContactToJson(this);
}

extension ContactExtension on Contact {
  Image? getContactImage() {
    var base64 = imageBase64;
    if (base64 != null) {
      try {
        return Image.memory(
            const Base64Codec().decode(base64.replaceAll('\n', '')));
      } catch (e) {
        return null;
      }
    } else {
      return null;
    }
  }
}
