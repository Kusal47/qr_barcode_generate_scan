import 'package:flutter/material.dart';

import '../../resources/export_resources.dart';
import '../export_common_widget.dart';
import '../export_custom_widget.dart';

Widget scanDetailsBottomSheet<M, A>({
  required M model,
  required String title,
  required List<A> actions,
  required List<Widget> Function(M model) contentBuilder,
  required void Function(A type, void Function(IconData, Color, Function()) assign) actionBuilder,
}) {
  return BaseWidget(
    builder: (context, config, theme) {
      return Container(
        width: double.maxFinite,
        decoration: const BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          shape: BoxShape.rectangle,
        ),
        child: Padding(
          padding: EdgeInsets.all(config.appHorizontalPaddingLarge()),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customTitleText(title, context),
              config.verticalSpaceMedium(),

              // Build content dynamically
              ...contentBuilder(model),

              config.verticalSpaceMedium(),

              // Build actions dynamically
              buildActionRow<A>(actions: actions, config: config, onActionTap: actionBuilder),

              config.verticalSpaceMedium(),
            ],
          ),
        ),
      );
    },
  );
}

Widget buildActionRow<T>({
  required List<T> actions,
  required SizeConfig config,
  required void Function(T type, void Function(IconData icon, Color color, Function() onTap) assign)
  onActionTap,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children:
        actions.map<Widget>((type) {
          IconData? icon;
          Color? color;
          Function()? onTap;

          onActionTap(type, (i, c, f) {
            icon = i;
            color = c;
            onTap = f;
          });

          return circleAvatarMethodCustom(
            config,
            null,
            onTap: onTap,
            child: Icon(icon, color: color, size: config.appHeight(3)),
            radius: config.appHeight(3),
          );
        }).toList(),
  );
}

class FadePainter extends CustomPainter {
  final bool? isBarcode;
  FadePainter({this.isBarcode = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = blackColor.withOpacity(0.5)
          ..style = PaintingStyle.fill
          ..blendMode = BlendMode.dstOver;
    final Rect rect;

    if (isBarcode!) {
      final double rectWidth = size.width * 0.8;
      final double rectHeight = size.height * 0.25;

      rect = Rect.fromLTWH(
        (size.width - rectWidth) / 2,
        (size.height - rectHeight) / 2,
        rectWidth,
        rectHeight,
      );
    } else {
      final double rectSize = size.width * 0.5;

      rect = Rect.fromLTWH(
        (size.width - rectSize) / 2,
        (size.height - rectSize) / 2,
        rectSize,
        rectSize,
      );
    }

    final path =
        Path()
          ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
          ..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(20)))
          ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
