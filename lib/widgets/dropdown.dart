import 'package:flutter/material.dart';
import 'package:horeca/themes/app_color.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:horeca/widgets/text_field.dart';

class DropdownList extends StatefulWidget {
  final String? value;
  final ValueChanged<String>? selectedValue;
  final ValueChanged<String>? onChanged;
  final List<DropdownMenuItem<String>>? items;
  final TextEditingController? textController;
  final String hintText;
  final Icon icon;
  bool enable;
  DropdownList(
      {Key? key,
      this.selectedValue,
      this.value,
      this.onChanged,
      this.items,
      required this.hintText,
      this.textController,
      this.icon = const Icon(
        Icons.arrow_drop_down,
        color: Colors.black45,
        size: 30,
      ),
      this.enable = true})
      : super(key: key);

  @override
  State<DropdownList> createState() => _DropdownListState();
}

class _DropdownListState extends State<DropdownList> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
      elevation: 5.0,
      shadowColor: AppColor.backgroundColor,
      child: widget.enable == true
          ? DropdownButtonFormField2(
              value: widget.value,
              decoration: InputDecoration(
                //Add isDense true and zero Padding.
                //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                isDense: true,
                // contentPadding: EdgeInsets.zero,
                contentPadding: const EdgeInsets.all(-8),

                filled: true,
                fillColor: widget.enable
                    ? Colors.white
                    : AppColor.primaryBackgroundTextField,
                border: const OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 1, color: AppColor.primaryBackgroundTextField),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 1, color: AppColor.primaryBackgroundTextField),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 1, color: AppColor.primaryBackgroundTextField),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 1, color: AppColor.primaryBackgroundTextField),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 1, color: AppColor.primaryBackgroundTextField),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
              ),
              isExpanded: true,
              hint: widget.textController!.text.isNotEmpty
                  ? Text(
                      widget.textController!.text,
                      style: const TextStyle(
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColor.primaryText),
                    )
                  : Text(
                      widget.hintText,
                      style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColor.primaryText),
                    ),
              dropdownMaxHeight: MediaQuery.of(context).size.height / 2,
              icon: widget.icon,
              // iconSize: 30,
              buttonHeight: 58,
              buttonPadding: const EdgeInsets.only(left: 0, right: 15),
              // dropdownDecoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(15),
              // ),
              items: widget.items,
              dropdownPadding: const EdgeInsets.all(10),
              onChanged: (value) {
                print(value.toString());
                widget.onChanged?.call(value.toString());
                widget.textController?.text = value.toString();
                //Do something when changing the item if you want.
              },
              onSaved: (value) {
                widget.selectedValue!(value.toString());
                widget.textController?.text = value.toString();
              },
              style: const TextStyle(
                overflow: TextOverflow.ellipsis,
              ))
          : AppTextField(
              enable: widget.enable,
              controller: widget.textController,
            ),
    );
  }
}

class DropdownMenuItemSeparator<T> extends DropdownMenuItem<T> {
  final String name;
  final double width;

  DropdownMenuItemSeparator({required this.name, required this.width, Key? key})
      : super(
          key: key,
          child: SizedBox(
            width: width,
            child: Text(
              name,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ), // Trick the assertion.
        );
}
