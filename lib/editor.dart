import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:text_editor/editor_controller.dart';
import 'package:text_editor/text/text_cell.dart';
import 'package:text_editor/text/text_cell_widget.dart';

class Editor extends StatefulWidget {
  const Editor({
    super.key,
    required this.content,
  });

  final List<TextCell> content;

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  late EditorController controller;

  @override
  void initState() {
    super.initState();
    controller = EditorController(widget.content);
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (key) => controller.textCellEventsHandler.onEnterKeyPressed(key),
      child: ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, snapshot, _) {
            return ListView.builder(
              itemCount: controller.content.length,
              itemBuilder: (context, index) {
                return TextCellWidget(
                  textCell: controller.content.elementAt(index),
                  eventsHandler: controller.textCellEventsHandler,
                );
              },
            );
          }),
    );
  }
}
