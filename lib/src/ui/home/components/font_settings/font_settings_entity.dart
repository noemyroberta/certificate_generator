// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class FontSettingsEntity {
  String value;
  int fontSize;
  Color color;

  FontSettingsEntity(
    this.value, {
    this.fontSize = 20,
    this.color = Colors.black,
  });

  @override
  String toString() => 'FontSettingsEntity(value: $value, fontSize: $fontSize, color: $color)';
}
