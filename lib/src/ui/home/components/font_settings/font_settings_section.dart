import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:wit_md_certificate_gen/src/ui/home/components/font_settings/font_settings_entity.dart';
import 'package:wit_md_certificate_gen/src/ui/home/components/font_settings/font_settings_widget.dart';

class FontSettingsSection extends StatefulWidget {
  const FontSettingsSection({
    super.key,
    required this.selectedViewer,
    required this.initialText,
    required this.onTextChanged,
  });

  final List<FontSettingsEntity> selectedViewer;
  final String initialText;
  final ValueChanged<(int, FontSettingsEntity)> onTextChanged;

  @override
  State<FontSettingsSection> createState() => _FontSettingsSectionState();
}

class _FontSettingsSectionState extends State<FontSettingsSection> {
  List<FontSettingsEntity> get selectedViewer => widget.selectedViewer;
  String selectedText = "";
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
          items: _getItems(),
          onChanged: (String? newValue) {
            setState(() {
              selectedText = newValue!;
              selectedIndex = int.parse(newValue.substring(1, 2)) - 1;
            });
          },
        ),
        FontSettings(
          fontSize: selectedViewer[selectedIndex].fontSize,
          pickedColor: selectedViewer[selectedIndex].color,
          onFontSizeChanged: (newValue) {
            setState(() {
              selectedViewer[selectedIndex].fontSize = newValue;
              widget.onTextChanged(
                  (selectedIndex, selectedViewer[selectedIndex]));
            });
          },
          onColorPicked: (newColor) {
            setState(() {
              selectedViewer[selectedIndex].color = newColor;
              widget.onTextChanged(
                  (selectedIndex, selectedViewer[selectedIndex]));
            });
          },
        ),
      ],
    );
  }

  List<DropdownMenuItem<String>> _getItems() {
    List<DropdownMenuItem<String>> items = [];

    for (int i = 0; i < selectedViewer.length; i++) {
      items.add(DropdownMenuItem<String>(
        value: '#${i + 1} ${selectedViewer[i].value}',
        child: Text('#${i + 1} ${selectedViewer[i].value}'),
      ));
    }
    return items;
  }
  
}
