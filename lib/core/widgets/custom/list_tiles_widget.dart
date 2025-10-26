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
            fontWeight: titleFontWeight ?? FontWeight.bold,
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

Widget customExpansionTileWidget(
  BuildContext context,
  String title, {
  IconData? icon,
  Color? iconColor,
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
  IconData? leadingIcon,
  String? leadingImage,
  List<Widget> childrens = const [],
}) {
  return BaseWidget(
    builder: (context, config, theme) {
      return Column(
        children: [
          ExpansionTile(
            tilePadding: contentPadding ?? EdgeInsets.all(config.appHorizontalPaddingSmall()),

            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius ?? 5),
              side:
                  side ??
                  BorderSide(color: borderColor ?? Colors.transparent, width: borderWidth ?? 0),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius ?? 5),
              side:
                  side ??
                  BorderSide(color: borderColor ?? Colors.transparent, width: borderWidth ?? 0),
            ),

            // Leading widget handling
            leading:
                leadingWidget ??
                (leadingImage != null
                    ? Image.asset(
                      leadingImage,
                      height: config.appHeight(3),
                      width: config.appHeight(3),
                      fit: BoxFit.contain,
                    )
                    : (leadingIcon != null
                        ? Icon(
                          leadingIcon,
                          color: iconColor ?? theme.primaryColor,
                          size: iconSize ?? config.appHeight(3),
                        )
                        : null)),

            collapsedBackgroundColor: containerColor ?? Colors.white,
            backgroundColor: containerColor ?? Colors.white,

            childrenPadding: EdgeInsets.all(config.appHorizontalPaddingMedium()),

            title: Text(
              title,
              style: customTextStyle(
                fontWeight: titleFontWeight ?? FontWeight.bold,
                fontSize: titleFontSize ?? config.appHeight(2.0),
              ),
            ),

            subtitle:
                subtitle != null
                    ? DefaultTextStyle.merge(
                      style: customTextStyle(
                        fontWeight: subtitleFontWeight ?? FontWeight.normal,
                        fontSize: subtitleFontSize ?? config.appHeight(1.6),
                        color: subtitleColor ?? Colors.grey,
                      ),
                      child: subtitle,
                    )
                    : null,

            children: childrens,
          ),
          config.verticalSpaceSmall(),
        ],
      );
    },
  );
}
