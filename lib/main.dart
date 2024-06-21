import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wit_md_certificate_gen/src/ui/home/certificate_gen.dart';
import 'package:wit_md_certificate_gen/src/ui/home/components/generator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => Generator(),
      child: const CertificateGen(),
    ),
  );
}
