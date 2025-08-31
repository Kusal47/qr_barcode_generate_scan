import 'package:flutter/material.dart';
import '../../resources/colors.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final double? height;
  final double? width;
  final Color? color;
  final Color? backgroundColor;
  final double? radius;
  final Color? labelColor;
  final FontWeight? labelWeight;
  final VoidCallback onPressed;
  final double? fontSize;
  final EdgeInsets? padding;

  const PrimaryButton({
    super.key,
    required this.label,
    this.height,
    this.width,
    this.color,
    this.backgroundColor,
    this.radius,
    this.labelColor,
    this.labelWeight,
    required this.onPressed,
    this.fontSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: padding ?? const EdgeInsets.all(0),
        backgroundColor:
            backgroundColor ??
            (Theme.of(context).brightness == Brightness.dark ? secondaryColor : primaryColor),
        minimumSize: Size(width ?? double.maxFinite, height ?? 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius ?? 10)),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(
          color:
              labelColor ??
              (Theme.of(context).brightness == Brightness.dark ? whiteColor : whiteColor),
          fontSize: fontSize ?? 16,
          fontWeight: labelWeight ?? FontWeight.w600,
        ),
      ),
    );
  }
}

class PrimaryIconButton extends StatelessWidget {
  const PrimaryIconButton({
    super.key,
    required this.label,
    this.color,
    this.backgroundColor,
    this.radius,
    this.labelColor,
    this.labelWeight,
    required this.onPressed,
    this.fontSize,
    required this.icon,
    this.padding,
    this.height,
    this.iconAlignment,
    this.width,
  });
  final String label;
  final Color? color;
  final Color? backgroundColor;
  final double? radius;
  final Color? labelColor;
  final FontWeight? labelWeight;
  final VoidCallback onPressed;
  final double? fontSize;
  final Widget icon;
  final EdgeInsets? padding;
  final double? height;
  final double? width;
  final IconAlignment? iconAlignment;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      iconAlignment: iconAlignment ?? IconAlignment.end,
      onPressed: onPressed,
      icon: icon,
      label: Text(
        label,
        style: TextStyle(
          color:
              labelColor ??
              (Theme.of(context).brightness == Brightness.dark ? whiteColor : whiteColor),
          fontSize: fontSize ?? 16,
          fontWeight: labelWeight ?? FontWeight.w600,
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: padding ?? const EdgeInsets.all(0),
        backgroundColor:
            backgroundColor ??
            (Theme.of(context).brightness == Brightness.dark ? secondaryColor : primaryColor),
        minimumSize: Size(width ?? double.maxFinite, height ?? 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius ?? 10)),
        ),
      ),
    );
  }
}

class PrimaryOutlineButton extends StatelessWidget {
  final String label;
  final double? height;
  final double? width;
  final Color? color;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? radius;
  final Color? labelColor;
  final FontWeight? labelWeight;
  final VoidCallback onPressed;
  final double? fontSize;
  final EdgeInsets? padding;

  const PrimaryOutlineButton({
    super.key,
    required this.label,
    this.height,
    this.width,
    this.color,
    this.backgroundColor,
    this.radius,
    this.labelColor,
    this.labelWeight,
    required this.onPressed,
    this.fontSize,
    this.padding,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ElevatedButton.styleFrom(
        padding: padding ?? const EdgeInsets.all(0),
        backgroundColor: backgroundColor ?? null,
        minimumSize: Size(width ?? double.maxFinite, height ?? 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius ?? 10)),
        ),
        side: BorderSide(
          color:
              borderColor ??
              (Theme.of(context).brightness == Brightness.dark
                  ? blackColor.withOpacity(0.3)
                  : blackColor.withOpacity(0.3)),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(
          color:
              labelColor ??
              (Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor),
          fontSize: fontSize ?? 16,
          fontWeight: labelWeight ?? FontWeight.w600,
        ),
      ),
    );
  }
}
