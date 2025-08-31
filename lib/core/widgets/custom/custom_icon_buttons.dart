import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../resources/colors.dart';
import '../export_common_widget.dart';

circularIconButton(BuildContext context,
    {IconData? icon, Color? bgColor, Function()? onTap, Color? iconColor, double? iconSize}) {
  return BaseWidget(builder: (context, config, theme) {
    return CircleAvatar(
      backgroundColor: bgColor ?? whiteColor,
      child: IconButton(
          onPressed: onTap ??
              () {
                Get.back();
              },
          icon: Icon(
            icon ?? Icons.arrow_back_ios_sharp,
            size: iconSize ?? config.appHeight(2.5),
            color: iconColor ?? primaryColor,
          )),
    );
  });
}

roundedBorderIconButton(BuildContext context,
    {IconData? icon, Color? bgColor, Function()? onTap, Color? iconColor, double? radius}) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 10), color: bgColor ?? whiteColor),
    child: IconButton(
        onPressed: onTap ??
            () {
              Get.back();
            },
        icon: Icon(
          icon ?? Icons.arrow_back_ios,
          color: iconColor ?? primaryColor,
        )),
  );
}
