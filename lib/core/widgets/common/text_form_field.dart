import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

import '../../resources/colors.dart';
import 'base_widget.dart';
import '../custom/custom_widget.dart';

class PrimaryFormField extends HookWidget {
  final String? hintTxt;
  // final Widget? hintIcon;
  final bool? isFilled;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String) onSaved;
  final Widget? prefixIcon;
  final Widget? prefix;
  final bool? isPassword;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final int? maxLines;
  final int? minLines;
  final bool? autofocus;
  final Widget? suffixIcon;
  final String? initialValue;
  final bool? readOnly;
  final InputBorder? focusedBorder;
  final InputBorder? disabledBorder;
  final InputBorder? enabledBorder;
  final EdgeInsetsGeometry? contentPadding;
  final List<TextInputFormatter>? inputFormatters;
  final double? fontSize;
  final String? title;
  final String? label;
  final void Function()? onTap;
  final double? radius;
  final bool? showLable;
  final void Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final TextStyle? hintStyle;
  final Color? color;
  final Color? fillColor;
  final bool? enabled;
  final bool? hideBorder;
  final int? maxLength;
  final String? counterText;
  final AutovalidateMode? autovalidateMode;
  final Color? outlineBorderColor;
  final double? outlineBorderWidth;

  const PrimaryFormField({
    super.key,
    this.color,
    this.onTap,
    this.hintTxt,
    this.initialValue,
    // this.hintIcon,
    this.controller,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
    this.minLines,
    required this.onSaved,
    this.suffixIcon,
    this.prefixIcon,
    this.isPassword = false,
    this.isFilled = false,
    this.keyboardType,
    this.readOnly,
    this.focusedBorder,
    this.disabledBorder,
    this.enabledBorder,
    this.contentPadding,
    this.autofocus,
    this.inputFormatters,
    this.fontSize,
    this.title,
    this.label,
    this.radius,
    this.showLable = false,
    this.onFieldSubmitted,
    this.prefix,
    this.textInputAction,
    this.hintStyle,
    this.enabled,
    this.fillColor,
    this.hideBorder = false,
    this.maxLength,
    this.counterText,
    this.autovalidateMode,
    this.outlineBorderColor,
    this.outlineBorderWidth,
  });

  @override
  Widget build(BuildContext context) {
    final isPasswordVisible = useState(isPassword!);
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        showLable == false && title != null
            ? Text(
              title!,
              style: customTextStyle(
                color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                fontSize: fontSize ?? 14,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.visible,
              ),
            )
            : Container(),

        Visibility(
          visible: showLable == false && title != null,
          child: SizedBox(height: size.height * 0.005),
        ),
        TextFormField(
          onTapOutside: (event) {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          enabled: enabled ?? true,
          maxLength: maxLength,
          textInputAction: textInputAction ?? TextInputAction.next,
          onTap: onTap,
          minLines: minLines ?? 1,
          maxLines: maxLines,
          initialValue: initialValue,
          keyboardType: keyboardType,
          controller: controller,
          autovalidateMode: autovalidateMode ?? AutovalidateMode.onUserInteraction,
          validator: validator,
          onSaved: (value) {
            onSaved(value!);
          },
          readOnly: readOnly ?? false,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          autofocus: autofocus ?? false,
          obscureText: isPasswordVisible.value,
          decoration: InputDecoration(
            counterText: counterText ?? null,
            errorMaxLines: 2,
            prefixIcon: prefixIcon,
            prefix: prefix,
            prefixStyle: customTextStyle(
              color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),

            suffixIcon:
                isPassword!
                    ? InkWell(
                      onTap: () {
                        isPasswordVisible.value = !isPasswordVisible.value;
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                        child: Icon(
                          isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                          size: 25,
                          color:
                              Theme.of(context).brightness == Brightness.dark
                                  ? whiteColor
                                  : primaryColor,
                        ),
                      ),
                    )
                    : suffixIcon,
            label: showLable == true ? Text(label!) : null,

            hintText: hintTxt,

            hintStyle:
                hintStyle ??
                Theme.of(context).textTheme.bodySmall?.copyWith(
                  color:
                      Theme.of(context).brightness == Brightness.dark ? whiteColor : darkGreyColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
            labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
              fontSize: 16,
            ),
            filled: isFilled!,
            isDense: true,
            contentPadding:
                contentPadding ??
                EdgeInsets.symmetric(
                  horizontal: size.width * 0.02,
                  vertical: size.height * 0.02,
                ), //TODO: VERTICAL:12
            fillColor:
                fillColor ??
                (Theme.of(context).brightness == Brightness.dark ? whiteColor : whiteColor),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(radius ?? 5)),
              borderSide:
                  hideBorder!
                      ? BorderSide.none
                      : BorderSide(
                        width: 1,
                        color:
                            Theme.of(context).brightness == Brightness.dark ? redColor : redColor,
                      ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(radius ?? 5)),
              borderSide:
                  hideBorder!
                      ? BorderSide.none
                      : BorderSide(
                        width: 1,
                        color:
                            Theme.of(context).brightness == Brightness.dark ? redColor : redColor,
                      ),
            ),
            enabledBorder:
                enabledBorder ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(radius ?? 5)),
                  borderSide:
                      hideBorder!
                          ? BorderSide.none
                          : BorderSide(
                            width:outlineBorderWidth?? 1,
                            color:
                                outlineBorderColor ??
                                (Theme.of(context).brightness == Brightness.dark
                                    ? whiteColor
                                    : blackColor),
                          ),
                ),
            focusedBorder:
                focusedBorder ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(radius ?? 5)),
                  borderSide:
                      hideBorder!
                          ? BorderSide.none
                          : BorderSide(
                            width: outlineBorderWidth??1,
                            color:
                                outlineBorderColor ??
                                (Theme.of(context).brightness == Brightness.dark
                                    ? whiteColor
                                    : blackColor),
                          ),
                ),
            disabledBorder:
                disabledBorder ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radius ?? 5),
                  borderSide:
                      hideBorder!
                          ? BorderSide.none
                          : BorderSide(
                            color:
                                outlineBorderColor ??
                                (Theme.of(context).brightness == Brightness.dark
                                    ? whiteColor
                                    : blackColor),
                            width:outlineBorderWidth?? 1,
                          ),
                ),
          ),
          style: TextStyle(
            color:
                color ??
                (Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor),
            fontSize: fontSize ?? size.height * 0.02,
          ),
        ),
      ],
    );
  }
}

class PrimaryPhoneFormField extends HookWidget {
  final String? hintTxt;
  final bool? isFilled;
  final String? Function(PhoneNumber?)? validator;
  final void Function(PhoneNumber)? onChanged;
  final void Function(Country)? onCountryChanged;
  final void Function(PhoneNumber) onSaved;
  final Widget? prefixIcon;
  final Widget? prefix;
  final bool? isPassword;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final int maxLines;
  final int? minLines;
  final bool? autofocus;
  final Widget? suffixIcon;
  final String? initialValue;
  final bool? readOnly;
  final InputBorder? focusedBorder;
  final InputBorder? disabledBorder;
  final InputBorder? enabledBorder;
  final EdgeInsetsGeometry? contentPadding;
  final List<TextInputFormatter>? inputFormatters;
  final double? fontSize;
  final String? title;
  final String? label;
  final void Function()? onTap;
  final double? radius;
  final bool? showLable;
  final void Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final TextStyle? hintStyle;
  final Color? color;
  final Color? fillColor;
  final bool? enabled;
  final bool? hideBorder;

  const PrimaryPhoneFormField({
    super.key,
    this.color,
    this.onTap,
    this.hintTxt,
    this.initialValue,
    this.onCountryChanged,
    this.controller,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
    this.minLines,
    required this.onSaved,
    this.suffixIcon,
    this.prefixIcon,
    this.isPassword = false,
    this.isFilled = false,
    this.keyboardType,
    this.readOnly,
    this.focusedBorder,
    this.disabledBorder,
    this.enabledBorder,
    this.contentPadding,
    this.autofocus,
    this.inputFormatters,
    this.fontSize,
    this.title,
    this.label,
    this.radius,
    this.showLable = false,
    this.onFieldSubmitted,
    this.prefix,
    this.textInputAction,
    this.hintStyle,
    this.enabled,
    this.fillColor,
    this.hideBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: showLable == false,
          child: Text(
            title ?? '',
            style: customTextStyle(
              color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
              fontSize: fontSize ?? 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Visibility(
          visible: showLable == false && title != null,
          child: SizedBox(height: size.height * 0.005),
        ),
        IntlPhoneField(
          initialCountryCode: 'NP',
          dropdownIconPosition: IconPosition.trailing,
          pickerDialogStyle: PickerDialogStyle(
            width: size.width,
            countryNameStyle: customTextStyle(),
            searchFieldInputDecoration: InputDecoration(
              suffixIcon: const Icon(Icons.search),
              hintText: 'Search country',
              hintStyle: customTextStyle(color: blackColor, fontSize: 14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide: BorderSide(
                  width: 1,
                  color:
                      Theme.of(context).brightness == Brightness.dark
                          ? whiteColor
                          : blackColor.withOpacity(0.06),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide: BorderSide(
                  width: 1.5,
                  color:
                      Theme.of(context).brightness == Brightness.dark ? primaryColor : primaryColor,
                ),
              ),
            ),
          ),
          invalidNumberMessage: 'Invalid phone number',

          languageCode: 'en',
          enabled: enabled ?? true,
          textInputAction: textInputAction ?? TextInputAction.next,
          onTap: onTap,
          initialValue: initialValue,
          keyboardType: keyboardType ?? TextInputType.phone,
          controller: controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator,

          onSaved: (value) {
            onSaved(value!);
          },
          readOnly: readOnly ?? false,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          onCountryChanged: onCountryChanged,
          onSubmitted: onFieldSubmitted,
          autofocus: autofocus ?? false,
          decoration: InputDecoration(
            errorMaxLines: 1,
            prefixIcon: prefixIcon,
            prefix: prefix,
            prefixStyle: customTextStyle(
              color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            label: showLable == true ? Text(label!) : null,
            hintText: hintTxt,
            hintStyle:
                hintStyle ??
                Theme.of(context).textTheme.bodySmall?.copyWith(
                  color:
                      Theme.of(context).brightness == Brightness.dark ? whiteColor : darkGreyColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
            labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
              fontSize: 16,
            ),
            filled: isFilled!,
            isDense: true,
            contentPadding:
                contentPadding ??
                EdgeInsets.symmetric(
                  horizontal: size.width * 0.02,
                  vertical: size.height * 0.02,
                ), //TODO: VERTICAL:12
            fillColor:
                fillColor ??
                (Theme.of(context).brightness == Brightness.dark ? whiteColor : whiteColor),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(radius ?? 5)),
              borderSide:
                  hideBorder!
                      ? BorderSide.none
                      : BorderSide(
                        width: 1,
                        color:
                            Theme.of(context).brightness == Brightness.dark ? redColor : redColor,
                      ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(radius ?? 5)),
              borderSide:
                  hideBorder!
                      ? BorderSide.none
                      : BorderSide(
                        width: 1,
                        color:
                            Theme.of(context).brightness == Brightness.dark ? redColor : redColor,
                      ),
            ),
            enabledBorder:
                enabledBorder ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(radius ?? 5)),
                  borderSide:
                      hideBorder!
                          ? BorderSide.none
                          : BorderSide(
                            width: 1,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? whiteColor
                                    : blackColor,
                          ),
                ),
            focusedBorder:
                focusedBorder ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(radius ?? 5)),
                  borderSide:
                      hideBorder!
                          ? BorderSide.none
                          : BorderSide(
                            width: 1,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? whiteColor
                                    : blackColor,
                          ),
                ),
            disabledBorder:
                disabledBorder ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radius ?? 5),
                  borderSide:
                      hideBorder!
                          ? BorderSide.none
                          : BorderSide(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? whiteColor
                                    : blackColor,
                            width: 1,
                          ),
                ),
          ),
          style: TextStyle(
            color:
                color ??
                (Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor),
            fontSize: fontSize ?? size.height * 0.02,
          ),
        ),
      ],
    );
  }
}

class PrimaryTextField extends StatelessWidget {
  final Function(String)? onValueChange;
  final String hint;
  final String? prefixIconPath;
  final Widget? prefixIcon;
  final String? suffixIconPath;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final Color? border;
  final bool? readOnly;
  final bool? showError;
  final bool? autofocus;
  final Function()? onTap;
  final Function(String)? onSubmitted;
  final TextCapitalization textCapitalization;
  final Color? fillColor;
  final bool showLable;
  final bool obscureText;
  final FocusNode? focusNode;
  final double borderRadius;

  final int? maxLength;
  final int? maxLine;
  final bool? isEnabled;
  final List<TextInputFormatter>? inputFormatters;

  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;

  const PrimaryTextField({
    super.key,
    required this.hint,
    this.prefixIconPath,
    this.suffixIconPath,
    this.onValueChange,
    this.controller,
    this.validator,
    this.textInputAction,
    this.textInputType,
    this.border,
    this.readOnly = false,
    this.showError = true,
    this.textCapitalization = TextCapitalization.sentences,
    this.onTap,
    this.onSubmitted,
    this.autofocus = false,
    this.showLable = false,
    this.fillColor,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.isEnabled = false,
    this.focusNode,
    this.borderRadius = 10,
    this.maxLength,
    this.maxLine,
    this.inputFormatters,
    this.focusedBorder,
    this.enabledBorder,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (event) {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      maxLines: maxLine,
      enabled: isEnabled,
      focusNode: focusNode,
      obscureText: obscureText,
      autofocus: autofocus!,
      textCapitalization: textCapitalization,
      onFieldSubmitted: onSubmitted,
      onTap: (onTap != null) ? onTap! : null,
      readOnly: (readOnly == null) ? false : readOnly!,
      keyboardType: textInputType,
      textInputAction: textInputAction,
      // maxLines: 1,
      validator: (validator != null) ? validator : null,
      controller: (controller != null) ? controller : null,
      onChanged: (text) {
        if (onValueChange != null) {
          onValueChange!(text);
        }
      },
      decoration: InputDecoration(
        border: InputBorder.none,
        // OutlineInputBorder(
        //   borderSide: BorderSide(width: 0, color: greyColor),
        // ),
        label: showLable ? Text(hint, style: const TextStyle(color: greyColor)) : null,
        fillColor: fillColor ?? Colors.transparent,
        filled: true,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        // contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        enabledBorder:
            enabledBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
              borderSide: BorderSide(width: 1, color: (border == null) ? greyColor : border!),
            ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          borderSide: BorderSide(width: 1, color: (border == null) ? blackColor : border!),
        ),
        focusedBorder:
            focusedBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
              borderSide: BorderSide(width: 1, color: (border == null) ? blackColor : border!),
            ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          borderSide: const BorderSide(width: 1, color: blackColor),
        ),
        errorStyle: (showError!) ? const TextStyle(fontSize: 12) : const TextStyle(fontSize: 0),
        hintText: hint,
        hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: greyColor,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      textAlign: TextAlign.left,
      style: customTextStyle(
        color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomDropdownFormField<T> extends StatelessWidget {
  final List<T>? items;
  final T? value;
  void Function(T?)? onChanged;
  final String Function(T)? displayText;
  final String? hintText;
  final InputDecoration? decoration;
  final UnderlineInputBorder? border;
  String? Function(T?)? validator;
  final String? title;

  CustomDropdownFormField({
    super.key,
    this.items,
    this.value,
    this.onChanged,
    this.displayText,
    this.hintText,
    this.decoration,
    this.border,
    this.validator,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: title != null,
          child: Text(
            title ?? '',
            style: customTextStyle(
              color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Visibility(visible: title != null, child: SizedBox(height: size.height * 0.005)),
        DropdownButtonFormField<T>(
          value: value,
          items:
              items?.map((T item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: Text(
                    displayText != null ? displayText!(item) : item.toString(),
                    style: customTextStyle(color: blackColor, fontSize: 16),
                  ),
                );
              }).toList(),
          onChanged: onChanged,
          validator: (value) => value == null ? "Select an item" : null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration:
              decoration ??
              InputDecoration(
                hintText: hintText ?? null,
                hintStyle: const TextStyle(
                  color: blackColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 12,
                ), //TODO: VERTICAL:10
                border:
                    border ??
                    const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(width: 1, color: blackColor),
                    ),
                errorBorder:
                    border ??
                    const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(width: 1, color: blackColor),
                    ),
                enabledBorder:
                    border ??
                    const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(width: 1, color: blackColor),
                    ),
                focusedBorder:
                    border ??
                    const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(width: 1, color: blackColor),
                    ),
                disabledBorder:
                    border ??
                    const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(width: 1, color: blackColor),
                    ),
              ),
          style: customTextStyle(color: blackColor, fontSize: 16),
        ),
      ],
    );
  }
}

class RadioChooseField<T> extends StatefulWidget {
  const RadioChooseField({
    super.key,
    required this.name,
    this.textInputType = TextInputType.text,
    required this.label,
    required this.items,
    this.onChanged,
    this.initialValue,
  });

  final String label;
  final String name;
  final TextInputType textInputType;
  final List<T> items;
  final Function(T?)? onChanged;
  final T? initialValue;

  @override
  State<RadioChooseField<T>> createState() => _RadioChooseFieldState<T>();
}

class _RadioChooseFieldState<T> extends State<RadioChooseField<T>> {
  T? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      builder: (context, config, themeData) {
        return Container(
          padding: EdgeInsets.all(config.appHorizontalPaddingMedium()),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Theme.of(context).brightness == Brightness.dark ? whiteColor : whiteColor,
            border: Border.all(
              color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.label,
                style: customTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                ),
              ),
              config.verticalSpaceVerySmall(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children:
                    widget.items.map((item) {
                      return RadioMenuButton<T>(
                        toggleable: true,
                        value: item,
                        groupValue: selectedValue,
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value;
                          });
                          if (widget.onChanged != null) {
                            widget.onChanged!(value);
                          }
                        },
                        child: Text(
                          item.toString(),
                          style: customTextStyle(
                            fontSize: 16,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? whiteColor
                                    : blackColor,
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
