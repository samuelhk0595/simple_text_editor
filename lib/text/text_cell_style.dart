import 'package:flutter/cupertino.dart';

enum TextCellStyle {
  title,
  h1,
  h2,
  h3,
  paragraph,
}

extension TextCellStyleExtension on TextCellStyle {
  TextStyle get style {
    switch (this) {
      case TextCellStyle.title:
        return TextStyle(fontSize: 22);
      case TextCellStyle.h1:
        return TextStyle(fontSize: 30);
      case TextCellStyle.h2:
        return TextStyle(fontSize: 25);
      case TextCellStyle.h3:
        return TextStyle(fontSize: 20);
      case TextCellStyle.paragraph:
        return TextStyle(fontSize: 18);
    }
  }
}
