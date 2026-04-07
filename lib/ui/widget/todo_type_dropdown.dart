import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';

class TodoTypeDropdown extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChangedValue;

  const TodoTypeDropdown({
    super.key,
    required this.onChangedValue,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    logInfo('TodoTypeDropdown $selected');

    return DropdownMenu<String>(
      initialSelection: selected,
      width: double.infinity,
      label: const Text('Type'),
      leadingIcon: const Icon(Icons.category_rounded),
      dropdownMenuEntries: const [
        DropdownMenuEntry(value: "DEFAULT", label: "Default"),
        DropdownMenuEntry(value: "CALL", label: "Call"),
        DropdownMenuEntry(value: "HOME_WORK", label: "Home work"),
      ],
      onSelected: (value) {
        if (value != null) {
          onChangedValue(value);
        }
      },
    );
  }
}
