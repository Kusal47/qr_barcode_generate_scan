import 'package:flutter/material.dart';

void showLoadingDialog(BuildContext context, {Widget? loadingWidget}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) =>
        loadingWidget ??
        const Center(
          child: CircularProgressIndicator(),
        ),
  );
}

void hideLoadingDialog(BuildContext context, {Widget? loadingWidget}) {
  Navigator.of(context).pop();
}
