import 'package:flutter/material.dart';

import '../../resources/colors.dart';
import '../common/base_widget.dart';
import 'custom_widget.dart';

Widget buildRow(BuildContext context, String label, String value,
    {double? labelfont,
    double? valuefont,
    Color? labelColor,
    Color? valueColor,
    Color? dividerColor,
    FontWeight? labelFontWeight,
    FontWeight? valueFontWeight,
    int? labelFlex,
    int? valueFlex}) {
  return BaseWidget(
    builder: (context, config, theme) {
      return Padding(
        padding:  EdgeInsets.symmetric(vertical: config.appVerticalPaddingSmall()),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: labelFlex ?? 4,
              child: Text(
                '$label ',
                style: customTextStyle(
                    fontSize: labelfont ?? 12,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.visible,
                    color: labelColor??(Theme.of(context).brightness == Brightness.dark ? whiteColor : primaryColor)),
              ),
            ),
            Expanded(
                child: Text(
              ':',
              style: customTextStyle(
                  fontSize: valuefont ?? 12,
                  fontWeight: labelFontWeight ?? FontWeight.w500,
                  overflow: TextOverflow.visible,
                  color: dividerColor ?? (Theme.of(context).brightness == Brightness.dark ? whiteColor : primaryColor)),
            )),
            Expanded(
              flex: valueFlex ?? 8,
              child: Text(
                value,
                style: customTextStyle(
                    fontSize: valuefont ?? 12,
                    fontWeight: valueFontWeight ?? FontWeight.w500,
                    overflow: TextOverflow.visible,
                    color: valueColor ?? (Theme.of(context).brightness == Brightness.dark ? whiteColor : primaryColor)),
              ),
            ),
          ],
        ),
      );
    }
  );
}
