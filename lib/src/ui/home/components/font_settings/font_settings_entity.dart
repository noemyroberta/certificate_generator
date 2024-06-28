import "dart:convert";
import "package:flutter/material.dart";

class FontSettingsEntity {
  String value;
  int fontSize;
  Color color;
  Offset? position;

  FontSettingsEntity(
    this.value, {
    this.fontSize = 20,
    this.color = Colors.black,
    this.position,
  });

  @override
  String toString() => "FontSettingsEntity(value: $value, fontSize: $fontSize,"
      "color: $color, position: $position)";

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "value": value,
      "fontSize": fontSize,
      "color": color.value,
      "position": {"dx": position?.dx, "dy": position?.dy},
    };
  }

  factory FontSettingsEntity.fromMap(Map<String, dynamic> map) {
    return FontSettingsEntity(
      map["value"] as String,
      fontSize: map["fontSize"] as int,
      color: Color(map["color"] as int),
      position: Offset(map["position"]["dx"], map["position"]["dy"]),
    );
  }

  String toJson() => json.encode(toMap());

  factory FontSettingsEntity.fromJson(String source) =>
      FontSettingsEntity.fromMap(json.decode(source) as Map<String, dynamic>);
}
