import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../resources/colors.dart';

void showSuccessToast(String message, {Color? color}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: color ?? greenColor,
    textColor: whiteColor,
    fontSize: 14.0,
  );
}

void showErrorToast(String message, {Color? color}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: color ?? Colors.red,
    textColor: whiteColor,
    fontSize: 14.0,
  );
}
