import 'package:flutter/material.dart';
import 'package:horeca/utils/extensions.dart';

class FormFieldLabel extends StatelessWidget {
  final String label;
  const FormFieldLabel(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: context.text.bodyMedium?.copyWith(fontWeight: FontWeight.w300),
    );
  }
}
