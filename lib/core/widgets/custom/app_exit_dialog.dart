import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../resources/colors.dart';
import 'custom_widget.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    super.key,
    required this.tilte,
    required this.content,
    required this.onYesPressed,
    this.fontWeight,
    this.fontSize,
    this.onNoPressed,
  });
  final String tilte;

  final String content;
  final VoidCallback onYesPressed;
  final VoidCallback? onNoPressed;
  final FontWeight? fontWeight;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: whiteColor,
      title: Text(
        tilte,
        style: TextStyle(
            fontSize: fontSize ?? 20, color: blackColor, fontWeight: fontWeight ?? FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      content: Text(
        content,
        style: TextStyle(
            fontSize: fontSize ?? 18,
            color: blackColor,
            fontWeight: fontWeight ?? FontWeight.normal),
        textAlign: TextAlign.center,
        //'Apologies for the inconvenience. We are working on getting this issue fixed. Please try again later.',
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: greenColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            onYesPressed();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Yes',
              style: customTextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: whiteColor,
              ),
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: redColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: onNoPressed ??
              () {
                Get.back();
              },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'No',
              style: customTextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: whiteColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Future<bool> showExitPopup(BuildContext context, {VoidCallback? onYesPressed}) async {
  return await showDialog(
        context: context,
        builder: (context) => CustomAlertDialog(
          tilte: 'App Exit',
          content: 'Are you sure you want to exit the app?',
          onYesPressed: onYesPressed?? () {
            SystemNavigator.pop();
          },
          onNoPressed: () => Navigator.of(context).pop(false),
        ),
      ) ??
      false;
}

Future<bool> showSwitchPopup(BuildContext context) async {
  return await showDialog(
        context: context,
        builder: (context) => CustomAlertDialog(
          tilte: 'App Exit',
          content: 'Are you sure you want to exit the app?',
          onYesPressed: () {
            Navigator.of(context).pop(true);
          },
          onNoPressed: () => Navigator.of(context).pop(false),
        ),
      ) ??
      false;
}
