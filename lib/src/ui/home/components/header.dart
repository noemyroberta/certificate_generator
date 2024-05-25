import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  // ignore: use_super_parameters
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Text(
          'Gerador de Certificado',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'RobotoSlab',
            fontWeight: FontWeight.normal,
            fontSize: 25,
          ),
        ),
        Image.asset(
          "assets/logo-laccan-completa-branca.png",
          width: 250,
        ),
      ],
    );
  }
}
