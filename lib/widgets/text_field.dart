import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:horeca/themes/app_color.dart';

class AppTextField extends StatelessWidget {
  TextEditingController? controller;
  String? placeHolder;
  String? errorText;
  bool? isPassword;
  void Function()? onChange;
  void Function()? onEditComplete;
  void Function(String)? onChanged;
  bool? obscureText;
  void Function()? onTapObscureIcon;
  Widget? prefixIcon;
  Widget? suffixIcon;
  int? maxLine;
  double radius;
  bool enable;
  FocusNode? focusNode;
  Color? color;

  TextInputType keyboardType;
  List<TextInputFormatter>? inputFormatters;
  final Function(String value)? onSubmitted;
  AppTextField(
      {Key? key,
      this.focusNode,
      this.onChanged,
      this.onEditComplete,
      this.controller,
      this.errorText,
      this.placeHolder,
      this.isPassword = false,
      this.obscureText = false,
      this.maxLine = 1,
      this.onTapObscureIcon,
      this.onChange,
      this.prefixIcon,
      this.suffixIcon,
      this.enable = true,
      this.inputFormatters,
      this.radius = 5,
      this.color = Colors.white,
      this.keyboardType = TextInputType.text,
      this.onSubmitted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      borderRadius: BorderRadius.circular(radius),
      color: AppColor.backgroundColor,
      elevation: errorText == null ? 5.0 : 0.0,
      shadowColor: AppColor.backgroundColor,
      child: TextField(
        focusNode: focusNode,
        onEditingComplete: onEditComplete,
        inputFormatters: inputFormatters,
        onSubmitted: onSubmitted,
        enabled: enable,
        onChanged: onChanged,
        onTap: onChange,
        keyboardType: maxLine == null ? TextInputType.multiline : keyboardType,
        maxLines: maxLine,
        style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColor.primaryText.withOpacity(0.8)),
        decoration: InputDecoration(
          isDense: true, // Added this
          contentPadding: EdgeInsets.all(12),
          filled: true,
          fillColor: enable == true ? color : AppColor.disableColor,
          border: OutlineInputBorder(
            borderSide: const BorderSide(
                width: 1, color: AppColor.primaryBackgroundTextField),
            borderRadius: BorderRadius.all(Radius.circular(radius)),
          ),

          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                width: 1, color: AppColor.primaryBackgroundTextField),
            borderRadius: BorderRadius.all(Radius.circular(radius)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                width: 1, color: AppColor.primaryBackgroundTextField),
            borderRadius: BorderRadius.all(Radius.circular(radius)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                width: 1, color: AppColor.primaryBackgroundTextField),
            borderRadius: BorderRadius.all(Radius.circular(radius)),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                width: 1, color: AppColor.primaryBackgroundTextField),
            // borderRadius: BorderRadius.all(Radius.circular(radius)),
          ),

          // errorBorder: OutlineInputBorder(
          //   borderSide: const BorderSide(
          //       width: 1, color: AppColor.primaryBackgroundTextField),
          //   borderRadius: BorderRadius.all(Radius.circular(radius)),
          // ),
          hintText: placeHolder,
          hintStyle: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w400,
              color: AppColor.primaryText.withOpacity(0.6)),
          // labelText: "Aaaa",

          errorText: errorText,
          errorStyle: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w400,
              color: AppColor.errorColor.withOpacity(0.6)),
          prefixIcon: prefixIcon,
          suffixIcon: isPassword == true
              ? Visibility(
                  visible: isPassword ?? true,
                  child: GestureDetector(
                    onTap: onTapObscureIcon,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(
                        obscureText == true
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColor.mainAppColor,
                      ),
                    ),
                  ),
                )
              : suffixIcon,
        ),
        obscureText: obscureText ?? true,
        controller: controller,
      ),
    );
  }
}
