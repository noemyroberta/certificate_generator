import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:wit_md_certificate_gen/src/ui/widgets/draggable_text.dart';

import '../../widgets/colors.dart';

class CertificateViewer extends StatefulWidget {
  const CertificateViewer({
    super.key,
    required this.imageBytes,
    required this.imageName,
    required this.csvData,
  });

  final Uint8List? imageBytes;
  final String? imageName;
  final List<List<dynamic>> csvData;

  @override
  State<CertificateViewer> createState() => _CertificateViewerState();
}

class _CertificateViewerState extends State<CertificateViewer> {
  final _aereaKey = GlobalKey();
  List<List<dynamic>> get csv => widget.csvData;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Expanded(
      child: SizedBox(
        key: _aereaKey,
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
              if (csv.isNotEmpty)
                ...csv[0].map(
                  (e) => DraggableText(
                    aereaKey: _aereaKey,
                    text: e.toString(),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
