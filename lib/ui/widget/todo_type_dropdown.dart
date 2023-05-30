import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';

class TodoTypeDropdown extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChangedValue;

  const TodoTypeDropdown({
    Key? key,
    required this.onChangedValue,
    required this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return returnDropDown();
  }

  Widget returnDropDown() {
    logInfo('TodoTypeDropdown $selected');
    return DropdownButton<String>(
      value: selected,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (value) => onChangedValue(value!),
      items: <String>["DEFAULT", "CALL", "HOME_WORK"]
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
