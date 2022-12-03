import 'package:flutter/cupertino.dart';
import 'package:text_editor/core/cell.dart';
import 'package:text_editor/text/text_cell_style.dart';

class TextCell extends Cell {
  TextCell({
    required this.index,
    this.initialText,
    this.hintText,
    this.style = TextCellStyle.paragraph,
    TextEditingController? controller,
    FocusNode? focusNode,
  }) {
    this.controller = controller ?? TextEditingController();
    if (initialText != null) this.controller.text = initialText!;
    this.focusNode = focusNode ?? FocusNode();
  }

  factory TextCell.newCell(int index, {String? text}) {
    String hintText = '';
    TextCellStyle style = TextCellStyle.paragraph;

    if (index == 0) {
      hintText = 'Sem título';
      style = TextCellStyle.title;
    }

    return TextCell(
      index: index,
      style: style,
      hintText: hintText,
      controller: TextEditingController(text: text),
    );
  }

  String? initialText;
  String? hintText;
  int index;
  TextCellStyle style;
  late FocusNode focusNode;
  late TextEditingController controller;
}
