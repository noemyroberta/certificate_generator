import 'package:flutter/material.dart';
import 'package:wit_md_certificate_gen/src/ui/widgets/colors.dart';
import 'package:wit_md_certificate_gen/src/ui/widgets/file_section.dart';
import 'package:wit_md_certificate_gen/src/ui/widgets/strings.dart';

import 'components/header.dart';

class CertificateGen extends StatelessWidget {
  const CertificateGen({super.key});

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
              padding: const EdgeInsets.all(40),
              child: const FileSection(
                title: backgroundTitleText,
                subtitle: backgroundSubtitleText,
                buttonIcon: Icons.photo,
                buttonTitle: 'Insira o fundo',
              ),
            )
          ],
        ),
      ),
    );
  }
}
