import 'package:cloud_firestore_odm/cloud_firestore_odm.dart';
import 'package:json_annotation/json_annotation.dart';

const firestoreSerializable = JsonSerializable(
  converters: firestoreJsonConverters,
  explicitToJson: true,
  createFieldMap: true,
  createPerFieldToJson: true,
);
