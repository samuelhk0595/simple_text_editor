import 'package:flutter/cupertino.dart';
import 'package:text_editor/event_handlers/text_cell_events_handler.dart';

import 'text/text_cell.dart';

class EditorController extends ValueNotifier {
  final List<TextCell> content;
  late final TextCellEventHandler textCellEventsHandler;

  EditorController(this.content) : super(0) {
    if (content.isEmpty) {
      content.add(TextCell.newCell(0));
    }
    textCellEventsHandler = TextCellEventHandler(
      onLineBreakInEmptyField: breakLineOnEmptyField,
      onLineBreakAtBeginningOfContent: breakLineAtBeginningOfContent,
      onLineBreakAtTheMiddleOfContent: breakLineAtTheMiddleOfContent,
      onLineBreakAtTheEndOfContent: breakLineAtTheEndOfContent,
    );
  }

  void breakLineOnEmptyField(TextCell cell) {
    final newCellIndex = cell.index + 1;
    addTextCell(newCellIndex);
    updateEditor();
    setCursorOnCell(content.elementAt(newCellIndex));
  }

  void breakLineAtBeginningOfContent(TextCell cell) {
    final newCellIndex = cell.index;
    addTextCell(newCellIndex);
    updateEditor();
    setCursorOnCell(content.elementAt(newCellIndex + 1),
        selection: const TextSelection.collapsed(offset: 0));
  }

  void breakLineAtTheMiddleOfContent(TextCell cell) {
    final textBeforeSelection =
        cell.controller.text.substring(0, cell.controller.selection.start);
    final textAfterSelection =
        cell.controller.text.substring(cell.controller.selection.start);

  
    cell.controller.text = textBeforeSelection;
    final newCellIndex = cell.index + 1;
    addTextCell(newCellIndex, text: textAfterSelection);
    updateEditor();
    setCursorOnCell(content.elementAt(newCellIndex),selection: const TextSelection.collapsed(offset: 0));
  }

  void breakLineAtTheEndOfContent(TextCell cell) {
    final newCellIndex = cell.index + 1;
    addTextCell(newCellIndex);
    updateEditor();
    setCursorOnCell(content.elementAt(newCellIndex));
  }

  void addTextCell(int index, {String? text}) {
    final newCell = TextCell.newCell(index, text: text);
    content.insert(index, newCell);
  }

  Future<void> setCursorOnCell(
    TextCell cell, {
    TextSelection? selection,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    cell.focusNode.requestFocus();
    if (selection != null) {
      cell.controller.selection = selection;
    }
  }

  void updateEditor() {
    int index = 0;
    while (index < content.length) {
      content.elementAt(index).index = index;
      index++;
    }
    notifyListeners();
  }
}