import 'dart:async';
import 'dart:convert';
import 'dart:developer';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' show AnchorElement;

import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:wit_md_certificate_gen/src/ui/home/components/font_settings/font_settings_entity.dart';

class GeneratorState extends ChangeNotifier {
  bool _downloading = false;
  bool get downloading => _downloading;

  change(bool state) {
    _downloading = state;
    notifyListeners();
  }
}

class Generator {
  final List<List<String>> csv;
  final List<FontSettingsEntity> settings;
  final Uint8List background;
  final List<pw.Document> pdfs;
  final Archive _archive;
  final BuildContext context;

  final _responses = StreamController<Uint8List>.broadcast();
  final _memoryPdfs = StreamController<pw.Document>.broadcast();

  Generator({
    required this.context,
    required this.csv,
    required this.background,
    this.settings = const [],
  })  : pdfs = [],
        _archive = Archive();

  Future<void> create() async {
    Provider.of<GeneratorState>(context, listen: false).change(true);
    createPDFs();

    _memoryPdfs.stream.listen((pw.Document pdf) async {
      log("Listening _memoryPdfs");
      try {
        Uint8List pdfByte = await pdf.save();
        _responses.sink.add(pdfByte);
      } catch (e) {
        log("Sinking memorypdf ${e.toString()}");
      }
    });

    int counter = 1;
    int csvLen = csv.length;
    _responses.stream.listen((pdfByte) {
      final fileName = "$counter.pdf";
      final arch = ArchiveFile(fileName, pdfByte.length, pdfByte);
      _archive.addFile(arch);
      if (counter == csvLen) {
        _responses.close();
      }
      counter++;
    }, onDone: () {
      _download();
    });
  }

  createPDFs() async {
    final font = await PdfGoogleFonts.robotoSlabBold();

    for (int i = 0; i < csv.length; i++) {
      final pdf = _toPDF(i, font);
      _memoryPdfs.sink.add(pdf);
    }
  }

  List<pw.Text> _getColumnTexts(int rowIndex, pw.Font font) {
    final List<pw.Text> texts = [];

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

  pw.Document _toPDF(int index, pw.Font font) {
    final pdf = pw.Document();
    final image = pw.MemoryImage(background);
    final texts = _getColumnTexts(index, font);

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

    return pdf;
  }

  Future<void> _download() async {
    if (context.mounted) {
      Provider.of<GeneratorState>(context, listen: false).change(false);
    }

    final zipEncoder = ZipEncoder();
    final zipData = zipEncoder.encode(_archive);
    final base64ZipData = base64Encode(zipData!);
    AnchorElement(href: "data:application/zip;base64,$base64ZipData")
      ..setAttribute("download", "certificados.zip")
      ..click();
  }
}
