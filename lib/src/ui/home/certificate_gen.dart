import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:wit_md_certificate_gen/src/ui/home/components/certificate_viewer.dart';
import 'package:wit_md_certificate_gen/src/ui/widgets/colors.dart';
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
  List<List<dynamic>> csvData = [];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return MaterialApp(
      title: 'WIT Certificate Gen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
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
                      ],
                    ),
                  ),
                  CertificateViewer(
                    imageBytes: imageBytes,
                    imageName: imageName,
                    csvData: csvData,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
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
      log(content);

      List<List<dynamic>> csvTable =
          const CsvToListConverter().convert(content);
      setState(() {
        csvData = csvTable;
      });
    }
  }
}
