import 'package:flutter/material.dart';

import 'colors.dart';

class FileSection extends StatelessWidget {
  // ignore: use_super_parameters
  const FileSection({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.buttonTitle,
    this.buttonIcon,
    this.buttonBackgroundColor,
    this.buttonTitleColor,
    this.gettedFileName,
    this.onPressed,
    this.titleSize,
  }) : super(key: key);

  final String title;
  final double? titleSize;
  final String subtitle;
  final String buttonTitle;
  final IconData? buttonIcon;
  final Color? buttonBackgroundColor;
  final Color? buttonTitleColor;
  final void Function()? onPressed;
  final String? gettedFileName;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.black87,
            fontFamily: 'RobotoSlab',
            fontWeight: FontWeight.w500,
            fontSize: titleSize ?? 25,
          ),
        ),
        Text(
          subtitle,
          style: const TextStyle(
            color: Colors.black54,
            fontFamily: 'RobotoSlab',
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            ElevatedButton.icon(
              style: ButtonStyle(
                foregroundColor:
                    WidgetStateColor.resolveWith((states) => primaryColor),
                backgroundColor: WidgetStateColor.resolveWith(
                    (states) => buttonBackgroundColor ?? primaryColor),
              ),
              onPressed: onPressed,
              icon: buttonIcon != null
                  ? Icon(buttonIcon, color: Colors.white)
                  : const SizedBox(),
              label: Text(
                buttonTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'RobotoSlab',
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 10),
            if (gettedFileName != null)
              Text(
                gettedFileName!,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'RobotoSlab',
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
