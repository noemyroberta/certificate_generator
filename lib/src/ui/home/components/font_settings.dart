import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:wit_md_certificate_gen/src/ui/home/components/font_settins/input_increment_decrement.dart';
import 'package:wit_md_certificate_gen/src/ui/widgets/colors.dart';
import 'package:wit_md_certificate_gen/src/ui/widgets/file_section.dart';

class FontSettings extends StatefulWidget {
  const FontSettings({
    super.key,
    required this.position,
    required this.text,
    this.onColorPicked,
    this.onFontSizeChanged,
  });

  final int position;
  final String text;
  final Function(Color)? onColorPicked;
  final Function(int)? onFontSizeChanged;

  @override
  State<FontSettings> createState() => _FontSettingsState();
}

class _FontSettingsState extends State<FontSettings> {
  int get position => widget.position;
  String get text => widget.text;
  late Color pickedColor;

  void changeColor(Color color) {
    if (widget.onColorPicked != null) {
      setState(() {
        pickedColor = color;
        widget.onColorPicked!(color);
      });
    }
  }

  void changeSize(int size) {
    if (widget.onFontSizeChanged != null) {
      setState(() {
        widget.onFontSizeChanged!(size);
      });
    }
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
        Text(
          '#${position.toString()} - $text',
          style: const TextStyle(
            color: Colors.black87,
            fontFamily: 'RobotoSlab',
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FileSection(
              title: 'Cor',
              titleSize: 12,
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
                    fontSize: 12,
                  ),
                ),
                InputIncrementDecrement(
                  initialValue: "20",
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
                //setState(() => currentColor = pickerColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
