import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:certificate_generator/src/ui/home/components/font_settings/input_increment_decrement.dart';
import 'package:certificate_generator/src/ui/widgets/colors.dart';
import 'package:certificate_generator/src/ui/widgets/file_section.dart';

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
  late Color _pickedColor;

  void changeColor(Color color) {
    setState(() {
      _pickedColor = color;
    });
    widget.onColorPicked(color);
  }

  void changeSize(int size) {
    widget.onFontSizeChanged(size);
  }

  @override
  void initState() {
    _pickedColor = primaryColor;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant FontSettings oldWidget) {
    if (oldWidget.pickedColor != widget.pickedColor) {
      _pickedColor = widget.pickedColor;
    }
    super.didUpdateWidget(oldWidget);
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
              pickerColor: _pickedColor,
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
