import 'dart:convert';

import 'package:flutter/widgets.dart';

Image? parseImageFromBase64(String base64) {
  try {
    return Image.memory(
        const Base64Codec().decode(base64.replaceAll('\n', '')));
  } catch (e) {
    return null;
  }
}
