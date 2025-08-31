import 'package:flutter/material.dart';

import '../../resources/colors.dart';
import '../../resources/size_config.dart';
import 'custom_widget.dart';

customRowTitle(String title, String tailText, Function() onTap, SizeConfig config,
    {double? titleFontSize, double? tailTextFontSize}) {
  return Padding(
    padding: EdgeInsets.all(config.appHorizontalPaddingMedium()),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: customTextStyle(
                fontSize: titleFontSize ?? config.appHeight(2.2), fontWeight: FontWeight.bold),
          ),
        ),
        Visibility(
          visible: tailText.isNotEmpty,
          child: InkWell(
            onTap: onTap,
            child: Text(
              tailText,
              style: customTextStyle(
                  fontSize: tailTextFontSize ?? config.appHeight(1.5),
                  fontWeight: FontWeight.bold,
                  color: primaryColor),
            ),
          ),
        ),
      ],
    ),
  );
}
