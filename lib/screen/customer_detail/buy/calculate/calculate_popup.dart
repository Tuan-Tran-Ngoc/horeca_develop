import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:horeca/screen/customer_detail/buy/calculate/cubit/cubit/calculate_popup_cubit.dart';
import 'package:horeca/themes/app_color.dart';
import 'package:horeca/widgets/button.dart';

class CalculatePopup extends StatelessWidget {
  final double width;
  final double height;
  final int? number;
  final void Function(int) onResultChanged;

  const CalculatePopup(
      {Key? key,
      required this.width,
      required this.height,
      this.number,
      required this.onResultChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CalculatePopupCubit()..init(),
      child: CalculatePopupBody(
        width: width,
        height: height,
        number: number,
        onResultChanged: onResultChanged,
      ),
    );
  }
}

class CalculatePopupBody extends StatefulWidget {
  final double width;
  final double height;
  final int? number;
  final void Function(int) onResultChanged;

  const CalculatePopupBody(
      {super.key,
      required this.width,
      required this.height,
      this.number,
      required this.onResultChanged});

  @override
  State<StatefulWidget> createState() =>
      // ignore: no_logic_in_create_state
      _CalculatePopupBodyState(width: 1100, height: 500, number: number);
}

class _CalculatePopupBodyState extends State<CalculatePopupBody> {
  final double width;
  final double height;
  int? number;

  String equation = '0';
  _CalculatePopupBodyState(
      {required this.width, required this.height, this.number}) {
    equation = number.toString();
  }

  @override
  Widget build(BuildContext context) {
    print('width $width height $height');
    Widget calcButton(
      String buttonText,
      Color buttonColor,
      void Function()? buttonPressed,
    ) {
      return Container(
        width: width * 0.2 * 0.2,
        height: width * 0.2 * 0.2,
        // margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextButton(
          onPressed: buttonPressed,
          child: Text(
            buttonText,
            style: const TextStyle(fontSize: 20, color: Colors.black),
          ),
        ),
      );
    }

    Widget calcButtonSpec(
      String buttonText,
      Color buttonColor,
      void Function()? buttonPressed,
    ) {
      return Container(
        width: width * 0.2 * 0.25,
        height: width * 0.2 * 0.2,
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextButton(
          onPressed: buttonPressed,
          child: Text(
            buttonText,
            style: const TextStyle(fontSize: 20, color: Colors.black),
          ),
        ),
      );
    }

    Widget dialogContent(BuildContext context) {
      buttonPressed(String buttonText) {
        setState(() {
          if (buttonText == 'AC') {
            equation = '0';
          } else if (buttonText == 'delete') {
            equation = equation.substring(0, equation.length - 1);
            if (equation == '') {
              equation = '0';
            }
          } else {
            if (equation == '0') {
              equation = buttonText;
            } else {
              equation = equation + buttonText;
            }
          }
        });
      }

      return Container(
        width: width * 0.2,
        height: height * 0.55,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    equation,
                    style: const TextStyle(fontSize: 24, color: Colors.black),
                  ),
                  // const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      calcButton('7', Colors.white10, () => buttonPressed('7')),
                      calcButton('8', Colors.white10, () => buttonPressed('8')),
                      calcButton('9', Colors.white10, () => buttonPressed('9')),
                      calcButtonSpec(
                          'AC', Colors.white10, () => buttonPressed('AC')),
                    ],
                  ),
                  // const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      calcButton('4', Colors.white10, () => buttonPressed('4')),
                      calcButton('5', Colors.white10, () => buttonPressed('5')),
                      calcButton('6', Colors.white10, () => buttonPressed('6')),
                      calcButtonSpec(
                          'DE', Colors.white10, () => buttonPressed('delete')),
                    ],
                  ),
                  // const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      calcButton('1', Colors.white10, () => buttonPressed('1')),
                      calcButton('2', Colors.white10, () => buttonPressed('2')),
                      calcButton('3', Colors.white10, () => buttonPressed('3')),
                      calcButtonSpec(
                          '0', Colors.white10, () => buttonPressed('0')),
                    ],
                  ),
                  // const SizedBox(height: 20),
                ],
              ),
            ),
            Center(
              child: AppButton(
                title: AppLocalizations.of(context)!.confirm,
                backgroundColor: AppColor.mainAppColor,
                height: height * 0.42 * 0.15,
                width: width * 0.2,
                onPress: () {
                  Navigator.of(context).pop();
                  int quantity = int.tryParse(equation) ?? 0;
                  widget.onResultChanged(quantity);
                },
              ),
            ),
          ],
        ),
      );
    }

    return BlocConsumer<CalculatePopupCubit, CalculatePopupState>(
        listener: (context, state) {
      if (state is LoadingInit) {
        equation = number.toString();
      }
    }, builder: (context, state) {
      return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: dialogContent(context),
      );
    });
  }
}
