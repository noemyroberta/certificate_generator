import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:wit_md_certificate_gen/src/ui/widgets/draggable_text.dart';

import '../../widgets/colors.dart';

class CertificateViewer extends StatefulWidget {
  // ignore: use_super_parameters
  const CertificateViewer({
    Key? key,
    required this.imageBytes,
    required this.imageName,
    required this.texts,
  }) : super(key: key);

  final Uint8List? imageBytes;
  final String? imageName;
  final List<DraggableText> texts;

  @override
  State<CertificateViewer> createState() => _CertificateViewerState();
}

class _CertificateViewerState extends State<CertificateViewer> {
  List<DraggableText> get texts => widget.texts;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Expanded(
      child: SizedBox(
        height: size.height * 0.5,
        child: ColoredBox(
          color: primaryColor,
          child: Stack(
            children: [
              widget.imageBytes != null
                  ? Image.memory(widget.imageBytes!)
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
              if (texts.isNotEmpty) ...texts,
            ],
          ),
        ),
      ),
    );
  }
}
