import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class DraggableText extends StatefulWidget {
  // ignore: use_super_parameters
  const DraggableText({
    Key? key,
    required this.aereaKey,
    required this.imageKey,
    required this.text,
    this.fontSize,
    this.fontColor,
    this.onPositionedText,
  }) : super(key: key);

  final String text;
  final int? fontSize;
  final Color? fontColor;
  final GlobalKey aereaKey, imageKey;
  final Function(Offset)? onPositionedText;

  @override
  State<DraggableText> createState() => _DraggableTextState();
}

class _DraggableTextState extends State<DraggableText> {
  GlobalKey get aereaKey => widget.aereaKey;
  GlobalKey get imageKey => widget.imageKey;
  String get text => widget.text;
  int? get fontSize => widget.fontSize;
  Color? get fontColor => widget.fontColor;
  Offset _offset = const Offset(0, 0);
  Offset _realOffset = const Offset(0, 0);

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
          Offset viewer = _getLocalPosition(drag, aereaKey);
          Offset image = _getLocalPosition(drag, imageKey);
          Offset diff = Offset(viewer.dx - image.dx, viewer.dy - image.dy);
          _realOffset = Offset(viewer.dx - diff.dx, viewer.dy - diff.dy);

          setState(() {
            _offset = viewer;
            widget.onPositionedText!(_realOffset);
          });
        },
        child: _buildDraggableText(),
      ),
    );
  }

  Offset _getLocalPosition(DraggableDetails draggable, GlobalKey key) {
    RenderBox? box = key.currentContext!.findRenderObject() as RenderBox;
    return box.globalToLocal(draggable.offset);
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
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SizedBox(
            child: DefaultTextStyle(
              style: TextStyle(
                color: fontColor ?? Colors.black,
                fontFamily: 'RobotoSlab',
                fontWeight: FontWeight.normal,
                fontSize: fontSize != null ? fontSize as double : 20,
              ),
              child: Text(text),
            ),
          ),
        ),
      ),
    );
  }
}
