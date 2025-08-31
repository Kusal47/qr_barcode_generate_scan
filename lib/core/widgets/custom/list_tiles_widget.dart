import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../resources/export_resources.dart';
import '../export_common_widget.dart';
import 'custom_widget.dart';

Widget buildSettingItem(
  BuildContext context,
  IconData icon,
  String title, {
  page,
  Color? color,
  dynamic extra,
  void Function()? onTap,
  Color? titleColor,
  Widget? trailing,
}) {
  return BaseWidget(
    builder: (context, config, theme) {
      return ListTile(
        tileColor: Theme.of(context).brightness == Brightness.dark ? darkBgColor : whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(color: transparent, width: 0.3),
        ),

        contentPadding: EdgeInsets.symmetric(horizontal: config.appHorizontalPaddingSmall()),
        leading: Icon(icon, size: config.appHeight(3), color: color),
        title: customTitleText(
          title,
          context,
          fontSize: config.appHeight(2.0),
          fontWeight: FontWeight.w600,
          color:
              titleColor ??
              (Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor),
        ),
        onTap:
            onTap ??
            () {
              Get.toNamed(page, arguments: extra);
            },
        trailing: trailing,
      );
    },
  );
}

Widget customListTileWidget(
  BuildContext context,
  String title, {
  IconData? icon,
  Color? iconcolor,
  void Function()? onTap,
  Color? titleColor,
  Widget? trailing,
  Widget? leadingWidget,
  Widget? subtitle,
  Color? subtitleColor,
  double? titleFontSize,
  double? subtitleFontSize,
  FontWeight? titleFontWeight,
  FontWeight? subtitleFontWeight,
  double? iconSize,
  double? radius,
  BorderSide? side,
  Color? borderColor,
  double? borderWidth,
  Color? containerColor,
  EdgeInsetsGeometry? contentPadding,
}) {
  return BaseWidget(
    builder: (context, config, theme) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: containerColor ?? whiteColor,
        ),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 5),
            side: side ?? BorderSide(color: borderColor ?? transparent, width: borderWidth ?? 0.3),
          ),

          contentPadding: contentPadding ?? EdgeInsets.all(config.appHorizontalPaddingMedium()),
          leading:
              icon != null
                  ? Icon(icon, size: iconSize ?? config.appHeight(3), color: iconcolor)
                  : leadingWidget,
          title: customTitleText(
            title,
            context,
            fontSize: titleFontSize ?? config.appHeight(2.0),
            fontWeight: titleFontWeight ?? FontWeight.normal,
            color: titleColor ?? blackColor,
          ),
          subtitle: subtitle,
          // onTap: onTap ?? () {},
          trailing: trailing,
        ),
      );
    },
  );
}

// Future<dynamic> formatSelectionDialog(
//   BuildContext context,
//   SizeConfig config,
//   Function(String)? onTap, {
// }) {

//   return showDialog(
//     context: context,
//     builder:
//         (context) => StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               title: Text(
//                 'Select Sport Format',
//                 style: customTextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: config.appHeight(2.0),
//                 ),
//               ),
//               content: Wrap(
//                 spacing: config.appHorizontalPaddingSmall(),
//                 children: List.generate(
//                   ,
//                   (index) => InkWell(
//                     onTap: () {
//                       sportFormat = sportFormatLists[index];
//                       onTap!(sportFormat);
//                       setState(() {});
//                     },
//                     child: Chip(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(5),
//                         side: BorderSide(
//                           color: sportFormatLists[index] == sportFormat ? whiteColor : greyColor,
//                         ),
//                       ),
//                       backgroundColor:
//                           sportFormatLists[index] == sportFormat ? primaryColor : whiteColor,
//                       label: Text(
//                         sportFormatLists[index],
//                         style: customTextStyle(
//                           color: sportFormatLists[index] == sportFormat ? whiteColor : blackColor,
//                           fontSize: config.appHeight(1.75),
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               actions: [
//                 PrimaryButton(
//                   label: 'Confirm',
//                   onPressed: () {
//                     Get.back();
//                   },
//                 ),
//               ],
//             );
//           },
//         ),
//   );
// }
