import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:certificate_generator/src/ui/home/certificate_gen.dart';
import 'package:certificate_generator/src/ui/home/components/generator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => GeneratorState(),
      child: const CertificateGen(),
    ),
  );
}
