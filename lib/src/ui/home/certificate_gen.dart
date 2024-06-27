import 'dart:convert';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wit_md_certificate_gen/src/ui/home/components/certificate_viewer.dart';
import 'package:wit_md_certificate_gen/src/ui/home/components/font_settings/font_settings_entity.dart';
import 'package:wit_md_certificate_gen/src/ui/home/components/font_settings/font_settings_section.dart';
import 'package:wit_md_certificate_gen/src/ui/home/components/generator.dart';
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
  GlobalKey? imageKey;
  GlobalKey viewerKey = GlobalKey();
  String initialText = "";
  int selectedViewerIndex = 0;
  List<FontSettingsEntity> selectedViewer = [];
  List<List<FontSettingsEntity>> certificateViewer = [];
  List<List<String>> rows = [];

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
                          Visibility(
                            visible: selectedViewer.isNotEmpty,
                            child: FontSettingsSection(
                              initialText: initialText,
                              selectedViewer: selectedViewer,
                              onTextChanged: (text) {
                                setState(() {
                                  selectedViewer
                                      .elementAt(text.$1)
                                      .update(text.$2);
                                  certificateViewer
                                      .elementAt(selectedViewerIndex)
                                      .elementAt(text.$1)
                                      .update(text.$2);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    ..._getPreviewers(),
                    CertificateViewer(
                      key: viewerKey,
                      imageKey: (key) => imageKey = key,
                      imageBytes: imageBytes,
                      imageName: imageName,
                      onDownload: () async {
                        if (context.mounted) {
                          Provider.of<GeneratorState>(context, listen: false)
                              .change();
                        }
                        final gen = Generator(
                          context: context,
                          csv: rows,
                          background: imageBytes!,
                          settings: selectedViewer,
                        );

                        await gen.create();
                        if (context.mounted) {
                          Provider.of<GeneratorState>(context, listen: false)
                              .change();
                        }
                      },
                      texts: _getDraggablesText(),
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
      rows = const CsvToListConverter(
        shouldParseNumbers: false,
        eol: "\n",
      ).convert<String>(content, eol: "\n", shouldParseNumbers: false);
      _initializeFontSettings(rows);
    }
  }

  void _initializeFontSettings(List<List<String>> csv) {
    if (csv.isEmpty) {
      return;
    }

    for (int i = 0; i < csv.length; i++) {
      certificateViewer.insert(i, []);
      for (int j = 0; j < csv[i].length; j++) {
        certificateViewer[i].add(
          FontSettingsEntity(
            csv[i][j],
            fontSize: 20,
            color: Colors.black87,
          ),
        );
      }
    }

    selectedViewer = certificateViewer[0];
    setState(() {
      initialText = "#1 ${selectedViewer[0].value}";
    });
  }

  int? _getFontSizeByPos(int position) {
    for (int i = 0; i < selectedViewer.length; i++) {
      if (i == position) {
        return selectedViewer[i].fontSize;
      }
    }
    return null;
  }

  Color? _getColorByPos(int position) {
    for (int i = 0; i < selectedViewer.length; i++) {
      if (i == position) {
        return selectedViewer[i].color;
      }
    }
    return null;
  }

  List<DraggableText> _getDraggablesText() {
    List<DraggableText> draggables = [];
    for (int i = 0; i < selectedViewer.length; i++) {
      final draggable = DraggableText(
        imageKey: imageKey!,
        aereaKey: viewerKey,
        currentPosition: selectedViewer.elementAt(i).position,
        onPositionedText: (offset) {
          selectedViewer.elementAt(i).position = offset;
          certificateViewer
              .elementAt(selectedViewerIndex)
              .elementAt(i)
              .position = offset;
        },
        fontSize: _getFontSizeByPos(i),
        fontColor: _getColorByPos(i),
        text: getWithNoSpaceAtTheEnd(selectedViewer[i].value),
      );
      draggables.add(draggable);
    }
    return draggables;
  }

  List<Widget> _getPreviewers() {
    final List<Widget> previews = [];
    for (int i = 0; i < certificateViewer.length; i++) {
      previews.add(
        Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  selectedViewer = certificateViewer[i];
                  selectedViewerIndex = i;
                });
              },
              child: SizedBox(
                height: 50,
                width: 20,
                child: ColoredBox(
                  color: primaryColor,
                  child: Text(
                    "${i + 1}",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      );
    }
    return previews;
  }
}
