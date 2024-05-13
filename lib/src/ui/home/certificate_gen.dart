import 'package:flutter/material.dart';

class CertificateGen extends StatelessWidget {
  const CertificateGen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WIT Certificate Gen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: const Scaffold(),
    );
  }
}