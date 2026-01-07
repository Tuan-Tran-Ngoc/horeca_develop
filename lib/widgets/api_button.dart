import 'package:flutter/material.dart';
import 'package:horeca/utils/api_call_manager.dart';
import 'package:horeca/widgets/button.dart';

/// A button widget that prevents double clicks and shows loading state
class ApiButton extends StatefulWidget {
  final String text;
  final Future<void> Function() onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final Duration? cooldownDuration;
  final String apiKey;
  final bool enabled;

  const ApiButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.apiKey,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.cooldownDuration,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<ApiButton> createState() => _ApiButtonState();
}

class _ApiButtonState extends State<ApiButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cooldown = widget.cooldownDuration ?? Duration(seconds: 3);
    final canMakeCall = ApiCallManager.canMakeCall(widget.apiKey, cooldown);
    final isEnabled = widget.enabled && canMakeCall && !_isLoading;
    
    String buttonText = widget.text;
    if (_isLoading) {
      buttonText = "${widget.text}...";
    }

    return AppButton(
      title: buttonText,
      backgroundColor: isEnabled 
          ? (widget.backgroundColor ?? Colors.blue)
          : (widget.backgroundColor ?? Colors.blue).withOpacity(0.6),
      textColor: widget.textColor ?? Colors.white,
      width: widget.width,
      height: widget.height,
      onPress: isEnabled ? _handlePress : null,
    );
  }

  Future<void> _handlePress() async {
    if (_isLoading || !ApiCallManager.canMakeCall(widget.apiKey, widget.cooldownDuration ?? Duration(seconds: 3))) {
      return;
    }

    await ApiCallManager.executeApiCall(
      key: widget.apiKey,
      cooldownDuration: widget.cooldownDuration ?? Duration(seconds: 3),
      onLoading: (isLoading) {
        if (mounted) {
          setState(() {
            _isLoading = isLoading;
          });
        }
      },
      apiCall: widget.onPressed,
    );
  }

  @override
  void dispose() {
    // Clean up the API call state when widget is disposed
    // Note: We don't clear the cooldown timer as it should persist
    super.dispose();
  }
}