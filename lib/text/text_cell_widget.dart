import 'package:flutter/material.dart';
import 'package:text_editor/event_handlers/text_cell_events_handler.dart';
import 'package:text_editor/text/text_cell_style.dart';

import 'text_cell.dart';

class TextCellWidget extends StatelessWidget {
  const TextCellWidget({
    super.key,
    required this.textCell,
    required this.eventsHandler,
  });

  final TextCell textCell;
  final TextCellEventHandler eventsHandler;

  @override
  Widget build(BuildContext context) {
    return EditableText(
      focusNode: textCell.focusNode,
      cursorColor: Colors.red,
      backgroundCursorColor: Colors.green,
      // onTap: () => eventsHandler.onTap(textCell),
      // decoration: InputDecoration.collapsed(
      //   hintText: textCell.hintText,
      // ),
      controller: textCell.controller,
      style: textCell.style.style,
      onChanged: (text) => eventsHandler.onLineGotEmpty(textCell),
      onSubmitted: (_) => eventsHandler.onSubmitted(textCell),
    );
  }
}
