import 'dart:developer';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:wit_md_certificate_gen/src/ui/widgets/colors.dart';

class Generator {
  final List<List<String>> csv;
  final Offset position;
  final List<pw.TextStyle> styles;
  final Uint8List background;

  const Generator({
    required this.csv,
    required this.position,
    required this.background,
    this.styles = const [],
  });

  Future<List<pw.Text>> _getTextWithStyle() async {
    final List<pw.Text> texts = [];
    final font = await rootBundle.load("assets/RobotoSlab-ExtraBold.ttf");

    for (int j = 0; j < csv.length; j++) {
      for (int i = 0; i < csv[j].length; i++) {
        log(csv[j][i]);
        texts.add(
          pw.Text(
            csv[j][i].toString(),
            style: pw.TextStyle(
              font: pw.Font.ttf(font),
              color: PdfColor.fromInt(primaryColor.value),
              fontSize: 20,
            ),
          ),
        );
      }
    }
    return texts;
  }

  createPDF() async {
    final pdf = pw.Document();
    final image = pw.MemoryImage(background);
    final texts = await _getTextWithStyle();
    final encoder = ZipFileEncoder();
    encoder.create('certificates.zip');

    for (int i = 0; i < csv.length; i++) {
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Stack(
              children: [
                pw.Image(image),
                ...texts.map(
                  (text) {
                    return pw.Positioned(
                      left: position.dx,
                      top: position.dy,
                      child: text,
                    );
                  },
                ),
              ],
            );
          },
        ),
      );
      File file = File('${i + 1}.pdf');
      await file.writeAsBytes(await pdf.save());
      encoder.addFile(file);
    }

    encoder.close();
  }
}
