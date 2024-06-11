import 'package:flutter/material.dart';

class ChangeTierRadioButton extends StatefulWidget {
  const ChangeTierRadioButton(
      {super.key, required this.currentTier, required this.onValueChanged});

  final String currentTier;
  final ValueChanged<String> onValueChanged;

  @override
  State<ChangeTierRadioButton> createState() => _ChangeTierRadioButtonState();
}

class _ChangeTierRadioButtonState extends State<ChangeTierRadioButton> {
  late String _selectedValue;

  @override
  void initState() {
    super.initState();
    if (widget.currentTier == "Viewer") {
      _selectedValue = "Viewer";
    } else if (widget.currentTier == "Poster") {
      _selectedValue = "Poster";
    } else if (widget.currentTier == "Admin") {
      _selectedValue = "Admin";
    }
  }

  void _handleValueChange(String? value) {
    setState(() {
      _selectedValue = value!;
    });
    widget.onValueChanged(_selectedValue);
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      ListTile(
          title: const Text('Viewer'),
          leading: Radio<String>(
            value: "Viewer",
            groupValue: _selectedValue,
            onChanged: _handleValueChange,
          )),
      ListTile(
          title: const Text('Poster'),
          leading: Radio<String>(
            value: "Poster",
            groupValue: _selectedValue,
            onChanged: _handleValueChange,
          )),
      ListTile(
          title: const Text('Admin'),
          leading: Radio<String>(
            value: "Admin",
            groupValue: _selectedValue,
            onChanged: _handleValueChange,
          )),
    ]);
  }
}
