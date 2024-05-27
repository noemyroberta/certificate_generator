import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:wit_md_certificate_gen/src/ui/widgets/colors.dart';
import 'package:wit_md_certificate_gen/src/ui/widgets/file_section.dart';

class FontSettings extends StatefulWidget {
  const FontSettings({
    super.key,
    required this.position,
    required this.text,
    this.onColorPicked,
  });

  final int position;
  final String text;
  final Function(Color?)? onColorPicked;

  @override
  State<FontSettings> createState() => _FontSettingsState();
}

class _FontSettingsState extends State<FontSettings> {
  int get position => widget.position;
  String get text => widget.text;

  void changeColor(Color color) {
    setState(() {
      if (widget.onColorPicked != null) {
        widget.onColorPicked!(color);
      }
    });
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
            fontSize: 25,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 12),
            FileSection(
              title: 'Cor',
              subtitle: 'Selecione a cor desse texto',
              buttonTitle: 'Selecionar a cor',
              buttonIcon: Icons.color_lens,
              onPressed: () {
                _showColorPickerDialog(context);
              },
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
              pickerColor: primaryColor,
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
