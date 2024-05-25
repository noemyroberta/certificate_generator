import 'package:flutter/material.dart';
import 'package:wit_md_certificate_gen/src/ui/widgets/colors.dart';
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    backgroundTitleText,
                    style: TextStyle(
                      color: Colors.black87,
                      fontFamily: 'RobotoSlab',
                      fontWeight: FontWeight.w500,
                      fontSize: 25,
                    ),
                  ),
                  const Text(
                    backgroundSubtitleText,
                    style: TextStyle(
                      color: Colors.black54,
                      fontFamily: 'RobotoSlab',
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateColor.resolveWith(
                          (states) => primaryColor),
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => primaryColor),
                    ),
                    onPressed: () {},
                    icon: const Icon(Icons.photo, color: Colors.white),
                    label: const Text(
                      'Inserir fundo',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'RobotoSlab',
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
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
}
