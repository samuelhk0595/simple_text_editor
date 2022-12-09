import 'package:flutter/material.dart';
import 'package:text_editor/event_handlers/text_cell_events_handler.dart';
import 'package:text_editor/text/text_cell_style.dart';

import 'text_cell.dart';

class TextCellWidget extends StatefulWidget {
  const TextCellWidget({
    super.key,
    required this.textCell,
    required this.eventsHandler,
  });

  final TextCell textCell;
  final TextCellEventHandler eventsHandler;

  @override
  State<TextCellWidget> createState() => _TextCellWidgetState();
}

class _TextCellWidgetState extends State<TextCellWidget> {
  DateTime selectionUpdateMoment = DateTime.now();
  int selectionExtent = 0;

  @override
  void initState() {
    widget.textCell.controller.addListener(updateSelection);
    super.initState();
  }

  void updateSelection() {
    final extent = widget.textCell.controller.selection.start -
        widget.textCell.controller.selection.end;
    if (extent != selectionExtent) {
      selectionExtent = extent;
      selectionUpdateMoment = DateTime.now();
      notifySelectionUpdateByTimeout(extent);
    }
  }

  void notifySelectionUpdateByTimeout(int extent) {
    Future.delayed(const Duration(milliseconds: 250), () {
      if (extent == selectionExtent) {
        widget.eventsHandler.updateSelection(widget.textCell);
      }
    });
  }

  @override
  void dispose() {
    widget.textCell.controller.removeListener(updateSelection);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: widget.textCell.key,
      padding: const EdgeInsets.all(4.0),
      child: TextField(
        focusNode: widget.textCell.focusNode,
        cursorColor: Colors.red,
        // onTap: () => eventsHandler.onTap(textCell),
        // decoration: InputDecoration.collapsed(
        //   hintText: textCell.hintText,
        // ),
        decoration: InputDecoration.collapsed(
          hintText: '',
          border: InputBorder.none,
        ),
        controller: widget.textCell.controller,
        style: widget.textCell.style.style,
        onChanged: (text) =>
            widget.eventsHandler.onLineGotEmpty(widget.textCell),
        onSubmitted: (_) => widget.eventsHandler.onSubmitted(widget.textCell),
      ),
    );
  }
}
