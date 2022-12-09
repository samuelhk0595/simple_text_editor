import 'package:flutter/material.dart';
import 'package:text_editor/editor_controller.dart';
import 'package:text_editor/text/text_cell.dart';
import 'package:text_editor/text/text_cell_style.dart';
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
  OverlayEntry? entry;

  @override
  void initState() {
    super.initState();
    controller = EditorController(widget.content);
    controller.addListener(() {
      entry?.remove();

      entry = OverlayEntry(builder: (context) {
        return Positioned(
          left: controller.styleModalOffset.dx,
          top: controller.styleModalOffset.dy,
          child: SizedBox(
            width: 200,
            height: 30,
            child: Material(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              elevation: 5.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    TextButton(
                      child: Text('Title'),
                      onPressed: () {
                        if (controller.selectedCell == null) return;
                        controller.content[controller.selectedCell!.index]
                            .style = TextCellStyle.title;
                            controller.notifyListeners();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
      Overlay.of(context)?.insert(entry!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (key) => controller.handleNavigationKeys(key),
      child: ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, snapshot, _) {
            return Stack(
              children: [
                ListView.builder(
                  itemCount: controller.content.length,
                  itemBuilder: (context, index) {
                    return TextCellWidget(
                      textCell: controller.content.elementAt(index),
                      eventsHandler: controller.textCellEventsHandler,
                    );
                  },
                ),
                // Positioned(
                //   left: controller.styleModalOffset.dx,
                //   top: controller.styleModalOffset.dy,
                //   child: Container(
                //     width: 200,
                //     height: 50,
                //     color: Colors.blue,
                //   ),
                // ),
              ],
            );
          }),
    );
  }
}
