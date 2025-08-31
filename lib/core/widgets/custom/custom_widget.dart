import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../resources/colors.dart';
import '../../resources/size_config.dart';

Icon buildCustomIcon(IconData iconData, {Color? color, double? size}) {
  return Icon(iconData, color: color ?? whiteColor, size: size ?? 20);
}

TextStyle customTextStyle({
  double? fontSize,
  Color? color,
  FontWeight? fontWeight,
  TextOverflow? overflow,
  TextDecoration? decoration,
  Color? decorationColor,
  double? decorationThickness,
  FontStyle? fontStyle,
  TextDecorationStyle? decorationStyle,
}) {
  return TextStyle(
    fontSize: fontSize ?? 14,
    color:
        color ?? (Theme.of(Get.context!).brightness == Brightness.dark ? whiteColor : blackColor),
    fontWeight: fontWeight ?? FontWeight.normal,
    decoration: decoration,
    fontStyle: fontStyle ?? FontStyle.normal,
    decorationColor: decorationColor,
    decorationThickness: decorationThickness,
    decorationStyle: decorationStyle,
    overflow: overflow ?? TextOverflow.ellipsis,
  );
}

customTextMessages(String message, BuildContext context) {
  return Center(
    child: Text(
      message,
      textAlign: TextAlign.center,
      style: customTextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color:
            Theme.of(context).brightness == Brightness.dark
                ? greyColor
                : blackColor.withOpacity(0.5),
      ),
    ),
  );
}

customTitleText(
  String message,
  BuildContext context, {
  double? fontSize,
  Color? color,
  FontWeight? fontWeight,
}) {
  return Text(
    message,
    style: customTextStyle(
      fontSize: fontSize ?? 20,
      fontWeight: fontWeight ?? FontWeight.bold,
      color: color ?? (Theme.of(context).brightness == Brightness.dark ? whiteColor : primaryColor),
      overflow: TextOverflow.visible,
    ),
  );
}

circleAvatarMethodCustom(
  SizeConfig config,
  ImageProvider<Object>? backgroundImage, {
  Color? bgColor,
  Widget? child,
  double? radius,
  Function()? onTap,
}) {
  return GestureDetector(
    onTap: onTap ?? () {},
    child: CircleAvatar(
      backgroundColor: bgColor ?? greyColor,
      radius: radius ?? config.appHeight(5),
      backgroundImage: backgroundImage,
      child: child,
    ),
  );
}

customButton(
  BuildContext context,
  SizeConfig config, {
  Function()? onTap,
  Icon? icon,
  Color? iconColor,
  Color? bgColor,
  double? iconSize,
  double? radius,
  BoxShape? boxShape,
}) {
  return GestureDetector(
    onTap:
        onTap ??
        () {
          Get.back();
        },
    child: Container(
      decoration: BoxDecoration(
        shape: boxShape ?? BoxShape.rectangle,
        borderRadius: boxShape == BoxShape.rectangle ? BorderRadius.circular(radius ?? 10) : null,
        color:
            bgColor ??
            (Theme.of(context).brightness == Brightness.dark ? primaryColor : whiteColor),
      ),
      padding: EdgeInsets.all(config.appHorizontalPaddingSmall()),
      child: Center(
        child:
            icon ??
            buildCustomIcon(
              Icons.arrow_back_ios_new,
              color:
                  iconColor ??
                  (Theme.of(context).brightness == Brightness.dark ? whiteColor : primaryColor),
              size: iconSize ?? config.appHeight(3),
            ),
      ),
    ),
  );
}

prefixCircleAvatarMethodCustom(
  SizeConfig config,
  ImageProvider<Object>? backgroundImage, {
  Color? bgColor,
  Gradient? gradient,
  Widget? child,
  double? radius,
}) {
  final double avatarRadius = radius ?? config.appHeight(5);

  return Container(
    width: avatarRadius * 2,
    height: avatarRadius * 2,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient:
          gradient ??
          LinearGradient(colors: tabGradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
      color: bgColor ?? greyColor,
    ),
    child: CircleAvatar(
      radius: avatarRadius,
      backgroundColor: transparent,
      backgroundImage: backgroundImage,
      child: backgroundImage == null ? child : null,
    ),
  );
}

containerWithOpacity(
  SizeConfig config,
  String text, {
  double? fontSize,
  FontWeight? fontWeight,
  Color? color,
  Color? textColor,
  Function()? onTap,
  double? radius,
  EdgeInsets? padding,
  double? height,
  double? width,
}) {
  return InkWell(
    onTap: onTap ?? null,
    child: Container(
      height: height ?? null,
      width: width ?? null,
      decoration: BoxDecoration(
        color: color ?? primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(radius ?? 5),
      ),
      padding: padding ?? EdgeInsets.all(config.appHorizontalPaddingMedium()),
      child: Center(
        child: Text(
          text,
          style: customTextStyle(
            color: textColor ?? primaryColor,
            fontSize: fontSize ?? config.appHeight(1.5),
            fontWeight: fontWeight ?? FontWeight.normal,
            overflow: TextOverflow.visible,
          ),
        ),
      ),
    ),
  );
}

Widget buildAssetImage(String imageUrl, {double? width, double? height, BoxFit? fit}) {
  return Image.asset(imageUrl, width: width, height: height, fit: fit ?? BoxFit.cover);
}

Widget buildNetworkImage(String imageUrl, {double? width, double? height, BoxFit? fit}) {
  return Image.network(imageUrl, width: width, height: height, fit: fit ?? BoxFit.cover);
}

Widget buildGenerateQrButton(
  BuildContext context,
  double width,
  double height,
  SizeConfig config,
  Function() onTap,
) {
  return InkWell(
    onTap: onTap,
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: whiteColor, borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.qr_code_scanner_sharp, color: blackColor, size: config.appHeight(8)),
          Text(
            'Generate QR',
            style: customTextStyle(
              fontSize: config.appHeight(2),
              color: blackColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildRowField(String label, BuildContext context, SizeConfig config) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        '•',
        style: customTextStyle(
          color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
          fontSize: config.appHeight(2.6),
          fontWeight: FontWeight.normal,
          overflow: TextOverflow.visible,
        ),
      ),
      config.horizontalSpaceSmall(),
      Expanded(
        child: Text(
          label,
          style: customTextStyle(
            color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
            fontSize: config.appHeight(1.8),
            fontWeight: FontWeight.normal,
            overflow: TextOverflow.visible,
          ),
        ),
      ),
    ],
  );
}

loginMethodsCard(
  SizeConfig config,
  String brand,
  Color? color, {
  ColorFilter? colorFilter,
  Function()? onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Card(
      elevation: 10,
      shadowColor: color ?? blackColor,
      margin: EdgeInsets.all(config.appHorizontalPaddingSmall()),
      shape: const CircleBorder(),
      child: Padding(
        padding: EdgeInsets.all(config.appHorizontalPaddingSmall()),
        child: Brand(brand, size: config.appHeight(4), colorFilter: colorFilter ?? null),
      ),
    ),
  );
}
