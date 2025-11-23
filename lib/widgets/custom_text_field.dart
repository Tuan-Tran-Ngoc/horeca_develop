import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final TextEditingController? controller;
  final bool enabled;
  final Function(String? value)? onChanged;
  final Widget? surfix;
  final FocusNode? focusNode;
  const CustomTextField(
      {super.key,
      this.label,
      this.controller,
      this.enabled = true,
      this.onChanged,
      this.surfix, this.focusNode});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      shadowColor: Colors.grey.shade100,
      shape: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(10.0),
      ),
      clipBehavior: Clip.hardEdge,
      child: TextField(
        cursorHeight: 16,
        enabled: enabled,
        focusNode: focusNode,
        // onEditingComplete: () => onChanged?.call(controller?.text),
        // onTapOutside: (_) => onChanged?.call(controller?.text),
        onChanged: (value) => onChanged?.call(value),
        decoration: InputDecoration(
            constraints: BoxConstraints(maxHeight: 50, minHeight: 50),
            labelText: label,
            fillColor: enabled ? Colors.white : Colors.grey.shade300,
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            suffixIcon: surfix),
        controller: controller,
      ),
    );
  }
}
