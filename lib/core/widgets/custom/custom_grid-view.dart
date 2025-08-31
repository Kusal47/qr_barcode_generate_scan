import 'package:flutter/material.dart';

class GridViewBuilderWidget extends StatelessWidget {
  const GridViewBuilderWidget(
      {super.key,
      required this.itemBuilder,
      required this.itemCount,
      this.chilApectRatio,
      this.crossAxisCount,
      this.mainAxisSpacing,
      this.crossAxisSpacing,
      this.padding});
  final Widget? Function(BuildContext, int) itemBuilder;
  final double? chilApectRatio;
  final int itemCount;
  final int? crossAxisCount;
  final double? mainAxisSpacing;
  final double? crossAxisSpacing;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(8.0),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: itemCount,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount ?? (MediaQuery.of(context).size.width < 700 ? 3 : 5),
          mainAxisSpacing: mainAxisSpacing ?? 10,
          crossAxisSpacing: crossAxisSpacing ?? 10,
          childAspectRatio: chilApectRatio ?? (MediaQuery.of(context).size.width < 700 ? 1 : 1),
        ),
        itemBuilder: itemBuilder,
      ),
    );
  }
}
