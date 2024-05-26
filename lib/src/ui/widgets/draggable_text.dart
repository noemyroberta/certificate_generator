import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class DraggableText extends StatefulWidget {
  // ignore: use_super_parameters
  const DraggableText({
    Key? key,
    required this.aereaKey,
    required this.text,
    this.fontSize,
    this.fontColor,
  }) : super(key: key);

  final String text;
  final double? fontSize;
  final Color? fontColor;
  final GlobalKey aereaKey;

  @override
  State<DraggableText> createState() => _DraggableTextState();
}

class _DraggableTextState extends State<DraggableText> {
  GlobalKey get aereaKey => widget.aereaKey;
  String get text => widget.text;
  double? get fontSize => widget.fontSize;
  Color? get fontColor => widget.fontColor;
  Offset _offset = const Offset(0, 0);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _offset.dx,
      top: _offset.dy,
      child: Draggable<String>(
        data: text,
        feedback: _buildDraggableText(),
        childWhenDragging: _buildDraggableText(),
        onDragEnd: (drag) {
          RenderBox? renderBox = aereaKey //
              .currentContext! //
              .findRenderObject() as RenderBox;
          final localOffset = renderBox //
              .globalToLocal(drag.offset);
          setState(() {
            _offset = localOffset;
          });
        },
        child: _buildDraggableText(),
      ),
    );
  }

  Widget _buildDraggableText() {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: const Radius.circular(8),
      color: Colors.white,
      strokeWidth: 2,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SizedBox(
            child: Text(
              text,
              style: TextStyle(
                color: fontColor ?? Colors.black,
                fontFamily: 'RobotoSlab',
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.italic,
                fontSize: fontSize ?? 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
