import 'package:flutter/material.dart';
import 'package:wit_md_certificate_gen/src/ui/home/components/font_settings/font_settings_entity.dart';
import 'package:wit_md_certificate_gen/src/ui/home/components/font_settings/font_settings_widget.dart';

class FontSettingsSection extends StatefulWidget {
  const FontSettingsSection({
    super.key,
    required this.header,
    required this.initialText,
    required this.onTextChanged,
  });

  final Map<int, FontSettingsEntity> header;
  final String initialText;
  final ValueChanged<(int, FontSettingsEntity)> onTextChanged;

  @override
  State<FontSettingsSection> createState() => _FontSettingsSectionState();
}

class _FontSettingsSectionState extends State<FontSettingsSection> {
  Map<int, FontSettingsEntity> get header => widget.header;
  String selectedText = '';
  int selectedIndex = 0;

  @override
  void initState() {
    selectedText = widget.initialText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selecione o texto para customizar',
          style: TextStyle(
            color: Colors.black87,
            fontFamily: 'RobotoSlab',
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        DropdownButton<String>(
          value: selectedText,
          items: header.entries.map((entry) {
            int index = entry.key;
            String text = entry.value.value;

            return DropdownMenuItem<String>(
              value: '#${index + 1} $text',
              child: Text('#${index + 1} $text'),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedText = newValue!;
              selectedIndex = int.parse(newValue.substring(1, 2)) - 1;
            });
          },
        ),
        FontSettings(
          fontSize: header[selectedIndex]!.fontSize,
          pickedColor: header[selectedIndex]!.color,
          onFontSizeChanged: (newValue) {
            setState(() {
              header[selectedIndex]!.fontSize = newValue;
              widget.onTextChanged((selectedIndex, header[selectedIndex]!));
            });
          },
          onColorPicked: (newColor) {
            setState(() {
              header[selectedIndex]!.color = newColor;
              widget.onTextChanged((selectedIndex, header[selectedIndex]!));
            });
          },
        ),
      ],
    );
  }
}
