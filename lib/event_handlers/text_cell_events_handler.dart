import 'package:flutter/services.dart';
import 'package:text_editor/text/text_cell.dart';

class TextCellEventHandler {
  TextCellEventHandler({
    required this.onLineBreakInEmptyField,
    required this.onLineBreakAtBeginningOfContent,
    required this.onLineBreakAtTheMiddleOfContent,
    required this.onLineBreakAtTheEndOfContent,
  });
  final void Function(TextCell cell) onLineBreakInEmptyField;
  final void Function(TextCell cell) onLineBreakAtBeginningOfContent;
  final void Function(TextCell cell) onLineBreakAtTheMiddleOfContent;
  final void Function(TextCell cell) onLineBreakAtTheEndOfContent;

  void onTap(TextCell textCell) {}
  void onSubmitted(TextCell textCell) {
    if (textCell.controller.text.isEmpty) {
      onLineBreakInEmptyField(textCell);
    } else if (textCell.controller.selection.start == 0) {
      onLineBreakAtBeginningOfContent(textCell);
    } else if (textCell.controller.selection.start > 0 &&
        textCell.controller.selection.start < textCell.controller.text.length) {
      onLineBreakAtTheMiddleOfContent(textCell);
    } else if (textCell.controller.selection.end ==
        textCell.controller.text.length) {
      onLineBreakAtTheEndOfContent(textCell);
    }
  }

  void onLineGotEmpty(TextCell textCell) {}
  void onEnterKeyPressed(dynamic key) {}
}
// if (key.data is RawKeyEventDataWeb) {
//           if ((key.data as RawKeyEventDataWeb).keyCode == 13) {
//             if (onEnterKeyPressed != null) {
//               onEnterKeyPressed!(textCell.index);
//             }
//           }
//         }