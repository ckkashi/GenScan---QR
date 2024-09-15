import 'package:flutter/material.dart';

class InputFields extends StatelessWidget {
  const InputFields({
    super.key,
    required this.name,
    required this.textEditingController,
    this.textBox = false,
  });
  final String name;
  final TextEditingController textEditingController;
  final bool textBox;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextField(
        maxLines: textBox ? 5 : 1,
        controller: textEditingController,
        decoration: InputDecoration(
          hintText: name != 'Code' ? 'Enter $name' : 'Code',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black87, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
