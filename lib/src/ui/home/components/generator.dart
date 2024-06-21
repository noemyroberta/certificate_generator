import 'dart:convert';
import 'dart:developer';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:wit_md_certificate_gen/src/ui/home/components/font_settings/font_settings_entity.dart';

class Generator extends ChangeNotifier {
  final List<List<String>> csv;
  final List<FontSettingsEntity> settings;
  final Uint8List background;
  final List<pw.Document> pdfs;
  bool _downloading = false;

  Generator({
    required this.csv,
    required this.background,
    this.settings = const [],
  }) : pdfs = [];

  bool get downloading => _downloading;

  Future<List<pw.Text>> _getColumnTexts(int rowIndex) async {
    final List<pw.Text> texts = [];
    final font = await PdfGoogleFonts.robotoBold();

    for (int i = 0; i < csv[rowIndex].length; i++) {
      texts.add(
        pw.Text(
          csv[rowIndex][i].toString(),
          style: pw.TextStyle(
            font: font,
            color: PdfColor.fromInt(settings[i].color.value),
            fontSize: settings[i].fontSize.toDouble(),
          ),
        ),
      );
    }

    return texts;
  }

  create() async {
    for (int i = 0; i < csv.length; i++) {
      final pdf = pw.Document();
      final image = pw.MemoryImage(background);
      final texts = await _getColumnTexts(i);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4.landscape,
          orientation: pw.PageOrientation.landscape,
          build: (pw.Context context) {
            return pw.Stack(
              children: [
                pw.Image(image),
                for (int j = 0; j < texts.length; j++)
                  pw.Positioned(
                    left: settings[j].position!.dx,
                    top: settings[j].position!.dy,
                    child: texts[j],
                  ),
              ],
            );
          },
        ),
      );
      pdfs.add(pdf);
    }
  }

  Future<void> download() async {
    if (pdfs.isEmpty) {
      log("PDFs not generated yet.");
      return;
    }

    final archive = Archive();

    for (int i = 0; i < pdfs.length; i++) {
      final pdf = pdfs[i];
      final savedFile = await pdf.save();
      final fileName = "${DateTime.now().millisecondsSinceEpoch}_$i.pdf";
      archive.addFile(ArchiveFile(fileName, savedFile.length, savedFile));
    }
    _setDownloadState(true);
    final zipEncoder = ZipEncoder();
    final zipData = zipEncoder.encode(archive);
    final base64ZipData = base64Encode(zipData!);
    html.AnchorElement(href: "data:application/zip;base64,$base64ZipData")
      ..setAttribute("download", "certificados.zip")
      ..click();
    _setDownloadState(false);
  }

  _setDownloadState(bool state) {
    _downloading = state;
    notifyListeners();
  }
}
