import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:certificate_generator/src/ui/home/components/generator.dart';
import 'package:certificate_generator/src/ui/widgets/draggable_text.dart';

import '../../widgets/colors.dart';

class CertificateViewer extends StatefulWidget {
  // ignore: use_super_parameters
  const CertificateViewer({
    Key? key,
    required this.imageBytes,
    required this.imageName,
    required this.texts,
    required this.onDownload,
    required this.imageKey,
  }) : super(key: key);

  final Uint8List? imageBytes;
  final String? imageName;
  final List<DraggableText> texts;
  final Function()? onDownload;
  final ValueSetter<GlobalKey> imageKey;

  @override
  State<CertificateViewer> createState() => _CertificateViewerState();
}

class _CertificateViewerState extends State<CertificateViewer> {
  List<DraggableText> get texts => widget.texts;
  GlobalKey imageKey = GlobalKey();

  @override
  void initState() {
    widget.imageKey(imageKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Expanded(
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.5,
            child: ColoredBox(
              color: primaryColor,
              child: Stack(
                children: [
                  widget.imageBytes != null
                      ? Center(
                          child: Image.memory(
                            key: imageKey,
                            widget.imageBytes!,
                            filterQuality: FilterQuality.high,
                          ),
                        )
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
          const SizedBox(height: 10),
          Consumer<GeneratorState>(builder: (_, state, child) {
            return Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                style: ButtonStyle(
                  foregroundColor: WidgetStateColor.resolveWith(
                    (states) => primaryColor,
                  ),
                  backgroundColor: WidgetStateColor.resolveWith(
                    (states) => primaryColor,
                  ),
                ),
                onPressed: widget.onDownload,
                icon: Icon(
                  state.downloading ? null : Icons.download_outlined,
                  color: Colors.white,
                ),
                label: Text(
                  state.downloading ? "Carregando..." : "Baixar certificados",
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'RobotoSlab',
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
