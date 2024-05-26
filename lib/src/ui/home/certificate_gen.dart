import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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
  Offset _offset = const Offset(0, 0);
  final aereaKey = GlobalKey();

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
                        const FileSection(
                          title: csvTitleText,
                          subtitle: csvSubtitleText,
                          buttonIcon: Icons.file_upload,
                          buttonTitle: 'Insira o arquivo CSV',
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      key: aereaKey,
                      height: size.height * 0.5,
                      child: ColoredBox(
                        color: primaryColor,
                        child: Stack(
                          children: [
                            imageBytes != null
                                ? Image.memory(imageBytes!)
                                : const Center(
                                    child: Text(
                                      'Seu fundo aparece aqui',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'RobotoSlab',
                                        fontWeight: FontWeight.normal,
                                        fontStyle: FontStyle.italic,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                            Positioned(
                              left: _offset.dx,
                              top: _offset.dy,
                              child: Draggable(
                                data: 'Lucy Roberta Santos',
                                feedback: _buildDraggableText(),
                                childWhenDragging: _buildDraggableText(),
                                onDragEnd: (drag) {
                                  RenderBox? renderBox = aereaKey
                                      .currentContext!
                                      .findRenderObject() as RenderBox;
                                  final localOffset =
                                      renderBox.globalToLocal(drag.offset);
                                  setState(() {
                                    _offset = localOffset;
                                  });
                                },
                                child: _buildDraggableText(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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

  Widget _buildDraggableText() {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: const Radius.circular(8),
      color: Colors.white,
      strokeWidth: 2,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SizedBox(
            child: Text(
              'Lucy Roberta Santos',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'RobotoSlab',
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.italic,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
