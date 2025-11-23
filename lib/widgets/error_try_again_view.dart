import 'package:flutter/material.dart';
import 'package:horeca/utils/extensions.dart';

class ErrorAndTryAgainView extends StatelessWidget {
  final VoidCallback onTryAgain;
  final String error;
  const ErrorAndTryAgainView(
      {super.key, required this.onTryAgain, required this.error});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            error,
            style: context.text.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: onTryAgain,
              child: Text('Thử lại'),
            ),
          )
        ],
      ),
    );
  }
}
