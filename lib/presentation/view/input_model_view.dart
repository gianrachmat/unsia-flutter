import 'package:flutter/material.dart';

class InputModelView extends StatefulWidget {
  final InputModel model;
  final String selectedRadio;
  final void Function(String?)? onRadioChanged;
  final void Function(String)? onButtonPressed;

  const InputModelView({
    super.key,
    required this.model,
    this.selectedRadio = '',
    this.onRadioChanged,
    this.onButtonPressed,
  });

  @override
  State<InputModelView> createState() => _InputModelView();
}

class _InputModelView extends State<InputModelView> {
  String _selectedRadio = '';

  @override
  void initState() {
    super.initState();
    _selectedRadio = widget.selectedRadio;
  }

  @override
  Widget build(BuildContext context) {
    InputModel e = widget.model;
    debugPrint('value ${e.value}');
    Widget item = Container();
    switch (e.type) {
      case InputType.title:
        item = Center(
          child: Text(
            e.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        );
        break;
      case InputType.text:
      case InputType.number:
        e.controller?.text = e.value;
        item = TextField(
          key: Key(e.title),
          readOnly: e.readOnly,
          controller: e.controller,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        );
        break;
      case InputType.radio:
        if (e.radioItem.isNotEmpty) {
          List<Widget> radios = [];
          for (var element in e.radioItem) {
            radios.add(
              Row(
                children: [
                  Radio<String>(
                    value: element,
                    groupValue: _selectedRadio,
                    onChanged: (selected) {
                      setState(() {
                        _selectedRadio = selected ?? '';
                        widget.onRadioChanged!(selected);
                      });
                    },
                  ),
                  Text(element),
                ],
              ),
            );
          }
          item = Column(children: radios);
        }
        break;
      case InputType.button:
        if (e.buttons.isNotEmpty) {
          List<Widget> buttons = [];
          for (var element in e.buttons) {
            buttons.add(OutlinedButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => widget.onButtonPressed!(element),
              child: Text(element),
            ));
          }
          item = Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: buttons,
            ),
          );
        }
        break;
      default:
        item = Container();
        break;
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          if (e.title != '' && e.type != InputType.title)
            Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: Text(e.title),
            ),
          Flexible(
            fit: FlexFit.tight,
            flex: 3,
            child: item,
          ),
        ],
      ),
    );
  }
}

enum InputType { title, text, number, radio, button }

class InputModel {
  String title;
  String field;
  String value;
  bool readOnly;
  InputType type;
  List<String> radioItem;
  List<String> buttons;
  TextEditingController? controller;
  String? date;

  InputModel(
    this.title,
    this.type, {
    this.field = '',
    this.value = '',
    this.readOnly = false,
    this.radioItem = const [],
    this.buttons = const [],
    this.controller,
    this.date,
  });
}

bool isNumeric(String str) {
  RegExp numeric = RegExp(r'^-?[0-9]+$');
  return numeric.hasMatch(str);
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String camelToSentence() {
    return replaceAllMapped(
      RegExp(r'^([a-z])|[A-Z]'),
      (Match m) => m[1] == null ? " ${m[0]}" : m[1]!.toUpperCase(),
    );
  }
}
