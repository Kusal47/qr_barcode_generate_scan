import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../resources/export_resources.dart';
import '../export_custom_widget.dart';

class ExpandableTextWidget extends StatefulWidget {
  final String text;
  final int trimLength;

  const ExpandableTextWidget({
    super.key,
    required this.text,
    this.trimLength = 100, // number of characters to show initially
  });

  @override
  State<ExpandableTextWidget> createState() => _ExpandableTextWidgetState();
}

class _ExpandableTextWidgetState extends State<ExpandableTextWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final displayText =
        isExpanded
            ? widget.text
            : (widget.text.length > widget.trimLength
                ? '${widget.text.substring(0, widget.trimLength)}...'
                : widget.text);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: displayText,
                style: customTextStyle(
                  color: darkGreyColor,
                  overflow: TextOverflow.visible,
                  fontSize: 12,
                ),
              ),
              if (widget.text.length > widget.trimLength)
                TextSpan(
                  recognizer:
                      TapGestureRecognizer()
                        ..onTap = () => setState(() => isExpanded = !isExpanded),
                  text: isExpanded ? ' Show less' : ' Show more',
                  style: customTextStyle(
                    fontSize: 12,
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.visible,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
