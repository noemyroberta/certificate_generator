import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:wit_md_certificate_gen/src/ui/home/components/certificate_viewer.dart';
import 'package:wit_md_certificate_gen/src/ui/home/components/font_settings.dart';
import 'package:wit_md_certificate_gen/src/ui/widgets/colors.dart';
import 'package:wit_md_certificate_gen/src/ui/widgets/draggable_text.dart';
import 'package:wit_md_certificate_gen/src/ui/widgets/file_section.dart';
import 'package:wit_md_certificate_gen/src/ui/widgets/strings.dart';

import 'components/header.dart';

class CertificateGen extends StatefulWidget {
  const CertificateGen({super.key});

  @override
  State<CertificateGen> createState() => _CertificateGenState();
}

class _CertificateGenState extends State<CertificateGen> {
  Uint8List? imageBytes;
  String imageName = '';
  GlobalKey aereaKey = GlobalKey();
  Map<int, Map<String, dynamic>> csv = {};
  String selectedText = '';
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return MaterialApp(
      title: 'WIT Certificate Gen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.1,
                width: double.infinity,
                child: const ColoredBox(
                  color: primaryColor,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Header(),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.2),
              Container(
                color: Colors.white70,
                padding: const EdgeInsets.symmetric(horizontal: 120),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: size.width * 0.5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FileSection(
                            title: backgroundTitleText,
                            subtitle: backgroundSubtitleText,
                            buttonIcon: Icons.photo,
                            buttonTitle: 'Insira o fundo',
                            onPressed: _uploadImage,
                            gettedFileName: imageName,
                          ),
                          const SizedBox(height: 50),
                          FileSection(
                            title: csvTitleText,
                            subtitle: csvSubtitleText,
                            buttonIcon: Icons.file_upload,
                            buttonTitle: 'Insira o arquivo CSV',
                            onPressed: _uploadFile,
                          ),
                          const SizedBox(height: 50),
                          if (csv.isNotEmpty)
                            const Text(
                              'Selecione o texto para customizar',
                              style: TextStyle(
                                color: Colors.black87,
                                fontFamily: 'RobotoSlab',
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          if (csv.isNotEmpty)
                            DropdownButton<String>(
                              value: selectedText,
                              items: csv.entries.map((entry) {
                                int index = entry.key;
                                String text = entry.value['value'];

                                return DropdownMenuItem<String>(
                                  value: '#${index + 1} $text',
                                  child: Text('#${index + 1} $text'),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedText = newValue!;
                                  selectedIndex =
                                      int.parse(newValue.substring(1, 2)) - 1;
                                });
                              },
                            ),
                          if (csv.isNotEmpty)
                            FontSettings(
                              onFontSizeChanged: (newValue) {
                                setState(() {
                                  csv[selectedIndex]!['size'] = newValue;
                                });
                              },
                              onColorPicked: (newColor) {
                                setState(() {
                                  csv[selectedIndex]!['color'] = newColor;
                                });
                              },
                            ),
                        ],
                      ),
                    ),
                    CertificateViewer(
                      key: aereaKey,
                      imageBytes: imageBytes,
                      imageName: imageName,
                      texts: csv.isNotEmpty
                          ? csv.entries.map((entry) {
                              int index = entry.key;
                              final value = entry.value;

                              return DraggableText(
                                aereaKey: aereaKey,
                                fontSize: _getFontSizeByPos(index),
                                fontColor: _getColorByPos(index),
                                text: getWithNoSpaceAtTheEnd(value['value']),
                              );
                            }).toList()
                          : [],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String getWithNoSpaceAtTheEnd(String text) {
    if (text.endsWith(' ')) {
      log('yes');
      String value = text.substring(0, text.length - 1);
      return value;
    }
    return text;
  }

  void _uploadImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'svg', 'jpeg']);

    if (result != null) {
      final bytes = result.files.first.bytes;
      final name = result.files.first.name;
      setState(() {
        imageBytes = bytes;
        imageName = name;
      });
    }
  }

  void _uploadFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['csv']);

    if (result != null) {
      PlatformFile file = result.files.first;
      Uint8List fileBytes = file.bytes!;
      String content = utf8.decode(fileBytes);

      List<List<dynamic>> csvTable =
          const CsvToListConverter().convert(content);
      _initializeFontSettings(csvTable);
    }
  }

  void _initializeFontSettings(List<List<dynamic>> csvTable) {
    if (csvTable.isNotEmpty) {
      for (int i = 0; i < csvTable[0].length; i++) {
        csv[i] = {
          'value': csvTable[0][i].toString(),
          'size': 20,
          'color': Colors.black87,
        };
      }
    }
    setState(() {
      selectedText = "#1 ${csv[0]!['value']}";
    });
  }

  double? _getFontSizeByPos(int position) {
    for (final setting in csv.entries) {
      if (setting.key == position) {
        return setting.value['size'];
      }
    }
    return null;
  }

  Color? _getColorByPos(int position) {
    for (var element in csv.entries) {
      if (element.key == position) {
        return element.value['color'];
      }
    }
    return null;
  }
}
