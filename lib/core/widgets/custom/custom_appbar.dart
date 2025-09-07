import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../resources/colors.dart';

AppBar buildAppBar(
  BuildContext context,
  String title, {
  List<Widget>? action,
  PreferredSizeWidget? bottom,
  Widget? leading,
  void Function()? onTap,
  bool? centerTitle = false,
  Color? textColor,
  Color? bgColor,
  Color? arrowColor,
  double? elevation,
  IconData? icon,
  bool? needToBack = true,
  bool? automaticallyImplyLeading = false,
  Key? key,
}) {
  final size = MediaQuery.of(context).size;
  return AppBar(
    key: key,
    centerTitle: centerTitle ?? false,
    automaticallyImplyLeading:
        automaticallyImplyLeading == true
            ? true
            : needToBack == true
            ? true
            : false,
    toolbarHeight: size.height * 0.08,
    elevation: elevation ?? 5,
    leading:
        needToBack == true
            ? InkWell(
              onTap:
                  onTap ??
                  () {
                    Get.back();
                  },
              child: Icon(
                icon ?? Icons.arrow_back_ios,
                color:
                    arrowColor ??
                    (Theme.of(context).brightness == Brightness.dark ? whiteColor : whiteColor),
                size: size.height * 0.03,
              ),
            )
            : leading,
    backgroundColor:
        bgColor ?? (Theme.of(context).brightness == Brightness.dark ? primaryColor : primaryColor),
    title: Text(
      title,
      style: TextStyle(
        color:
            textColor ??
            (Theme.of(context).brightness == Brightness.dark ? whiteColor : whiteColor),
        fontWeight: FontWeight.bold,
        fontSize: size.height * 0.025,
      ),
    ),
    actions: action,
    bottom: bottom,
  );
}
