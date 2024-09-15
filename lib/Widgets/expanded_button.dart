import 'package:flutter/material.dart';

class ExpandedButton extends StatelessWidget {
  const ExpandedButton({
    super.key,
    required this.name,
    required this.onTap,
  });

  final String name;

  final onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Text(name, style: TextStyle(color: Colors.white))),
          ),
        ),
      ),
    );
  }
}
