// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Contact _$ContactFromJson(Map<String, dynamic> json) => Contact(
      name: json['name'] as String?,
      phones:
          (json['phones'] as List<dynamic>).map((e) => e as String).toList(),
      imageBase64: json['imageBase64'] as String?,
    );

Map<String, dynamic> _$ContactToJson(Contact instance) => <String, dynamic>{
      'name': instance.name,
      'phones': instance.phones,
      'imageBase64': instance.imageBase64,
    };
