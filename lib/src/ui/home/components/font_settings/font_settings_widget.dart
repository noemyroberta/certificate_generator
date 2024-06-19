import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:wit_md_certificate_gen/src/ui/home/components/font_settings/input_increment_decrement.dart';
import 'package:wit_md_certificate_gen/src/ui/widgets/colors.dart';
import 'package:wit_md_certificate_gen/src/ui/widgets/file_section.dart';

class FontSettings extends StatefulWidget {
  const FontSettings({
    super.key,
    required this.onColorPicked,
    required this.onFontSizeChanged,
    required this.fontSize,
    required this.pickedColor,
  });

  final ValueChanged<Color> onColorPicked;
  final int fontSize;
  final Color pickedColor;
  final ValueChanged<int> onFontSizeChanged;

  @override
  State<FontSettings> createState() => _FontSettingsState();
}

class _FontSettingsState extends State<FontSettings> {
  late Color pickedColor;

  void changeColor(Color color) {
    setState(() {
      pickedColor = color;
    });
    widget.onColorPicked(color);
  }

  void changeSize(int size) {
    widget.onFontSizeChanged(size);
  }

  @override
  void initState() {
    pickedColor = primaryColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FileSection(
              title: 'Cor',
              titleSize: 14,
              subtitle: 'Selecione a cor do texto correspondente.',
              buttonTitle: 'Selecionar a cor',
              buttonBackgroundColor: Colors.purple[300],
              buttonTitleColor: Colors.black87,
              buttonIcon: Icons.color_lens,
              onPressed: () {
                _showColorPickerDialog(context);
              },
            ),
            const SizedBox(width: 12),
            Column(
              children: [
                const Text(
                  'Tamanho',
                  style: TextStyle(
                    color: Colors.black87,
                    fontFamily: 'RobotoSlab',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                InputIncrementDecrement(
                  initialValue: widget.fontSize,
                  onValueChanged: changeSize,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Future<dynamic> _showColorPickerDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Escolha a cor'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickedColor,
              onColorChanged: changeColor,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
