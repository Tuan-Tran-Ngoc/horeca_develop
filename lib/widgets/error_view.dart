import 'package:flutter/material.dart';
import 'package:horeca/utils/extensions.dart';

class ErrorView extends StatelessWidget {
  final String? error;
  final Widget? errorWidget;
  final VoidCallback? retry;
  ErrorView({Key? key, this.error, this.retry, this.errorWidget})
      : assert((error != null && error.isNotEmpty) || errorWidget != null,
            'Please specify error String or errorWidget'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          if (errorWidget != null) ...[
            errorWidget!
          ] else if (error != null) ...[
            Text(error!, style: context.text.bodyLarge)
          ],
          if (retry != null) ...[
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: retry,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  height: 50,
                  child: Text(
                    'Retry again',
                    style: context.text.bodyMedium,
                  ),
                ))
          ]
        ],
      ),
    );
  }
}
