import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:text_editor/event_handlers/text_cell_events_handler.dart';

import 'text/text_cell.dart';

class EditorController extends ValueNotifier {
  final List<TextCell> content;
  late final TextCellEventHandler textCellEventsHandler;
  Offset styleModalOffset = Offset.zero;
  TextCell? selectedCell;

  EditorController(this.content) : super(0) {
    if (content.isEmpty) {
      content.add(TextCell.newCell(0));
    }
    textCellEventsHandler = TextCellEventHandler(
      onSelectionUpdated: onSelectionUpdated,
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
    setCursorOnCell(content.elementAt(newCellIndex),
        selection: const TextSelection.collapsed(offset: 0));
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

  void onSelectionUpdated(TextCell cell) {
    try {
      RenderBox box = cell.key.currentContext?.findRenderObject() as RenderBox;
      styleModalOffset = box.localToGlobal(Offset.zero);
      styleModalOffset = styleModalOffset.translate(0, box.size.height * (-1.7));
      selectedCell = cell;
      notifyListeners();

    } catch (e) {
      print(e);
    }
  }

  Future<void> setCursorOnCell(
    TextCell cell, {
    bool useDelay = true,
    TextSelection? selection,
  }) async {
    if (useDelay) await Future.delayed(const Duration(milliseconds: 200));
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

  DateTime cursorChangeTimeStamp = DateTime.now();

  handleNavigationKeys(RawKeyEvent key) {
    if (DateTime.now().difference(cursorChangeTimeStamp).inMilliseconds < 100) {
      return;
    }
    final focusedIndex =
        content.indexWhere((element) => element.focusNode.hasFocus);
    if (key.data is RawKeyEventDataWeb) {
      if ((key.data as RawKeyEventDataWeb).keyCode == 38) {
        if (focusedIndex > 0) {
          final cell = content.elementAt(focusedIndex - 1);
          setCursorOnCell(
            cell,
            useDelay: false,
            selection: cell.controller.selection,
          );
        }
      } else if ((key.data as RawKeyEventDataWeb).keyCode == 40) {
        if (focusedIndex < content.length - 1) {
          final cell = content.elementAt(focusedIndex + 1);
          setCursorOnCell(
            cell,
            useDelay: false,
            selection: cell.controller.selection,
          );
        }
      }
    }
    cursorChangeTimeStamp = DateTime.now();
  }
}
