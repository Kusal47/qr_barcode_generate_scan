import 'package:flutter/material.dart';

import '../../resources/size_config.dart';
import '../common/base_widget.dart';
import '../common/shimmer_widget.dart';
import 'custom_grid-view.dart';

shimmerColumnRow(SizeConfig config, {int? count}) {
  return SingleChildScrollView(
    scrollDirection: Axis.vertical,
    child: Column(
      children: List.generate(count ?? 5, (index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: EdgeInsets.all(config.appHorizontalPaddingSmall()),
              child: ShimmerWidget.rounded(
                height: config.appHeight(16),
                width: config.appWidth(45),
                borderRadius: 2,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(config.appHorizontalPaddingSmall()),
              child: ShimmerWidget.rounded(
                height: config.appHeight(16),
                width: config.appWidth(45),
                borderRadius: 2,
              ),
            ),
          ],
        );
      }),
    ),
  );
}

shimmerGrid(SizeConfig config, {int? itemCount, int? count}) {
  return SingleChildScrollView(
    child: GridViewBuilderWidget(
      crossAxisCount: count ?? 2,
      mainAxisSpacing: config.appHeight(2),
      crossAxisSpacing: config.appHeight(2),
      itemBuilder: (context, index) => ShimmerWidget.rounded(borderRadius: 10),
      itemCount: itemCount ?? 5,
    ),
  );
}

rowShimmerEffect({bool? isExclusive = false, int? number, double? height, double? width}) {
  return BaseWidget(
    builder: (context, config, theme) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(number ?? 4, (index) {
            return Padding(
              padding: EdgeInsets.all(config.appHorizontalPaddingSmall()),
              child: ShimmerWidget.rounded(
                height: height ?? config.appHeight(20),
                width: width ?? config.appWidth(isExclusive == true ? 90 : 45),
                borderRadius: 10,
              ),
            );
          }),
        ),
      );
    },
  );
}

singleRowEffect({int? number, double? height, double? width}) {
  return BaseWidget(
    builder: (context, config, theme) {
      return Padding(
        padding: EdgeInsets.all(config.appHorizontalPaddingSmall()),
        child: ShimmerWidget.rounded(
          height: height ?? config.appHeight(20),
          width: width ?? double.maxFinite,
          borderRadius: 10,
        ),
      );
    },
  );
}

singleRowCircleEffect({int? number, double? height, double? width, double? circleRadius}) {
  return BaseWidget(
    builder: (context, config, theme) {
      return Padding(
        padding: EdgeInsets.all(config.appHorizontalPaddingSmall()),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ShimmerWidget.circular(radius: circleRadius ?? 30),
            config.horizontalSpaceVerySmall(),
            ShimmerWidget.rounded(
              height: height ?? config.appHeight(20),
              width: width ?? double.maxFinite,
              borderRadius: 5,
            ),
          ],
        ),
      );
    },
  );
}

class ShimmerClass extends StatelessWidget {
  const ShimmerClass({super.key, required this.config});
  final SizeConfig config;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          ShimmerWidget.rounded(
            height: config.appHeight(10),
            // width: config.appWidth(40),
            width: double.maxFinite,
            borderRadius: 5,
          ),
          Padding(
            padding: EdgeInsets.all(config.appHorizontalPaddingSmall()),
            child: ShimmerWidget.rounded(
              height: config.appHeight(25),
              // width: config.appWidth(40),
              width: double.maxFinite,
              borderRadius: 5,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(config.appHorizontalPaddingSmall()),
            child: ShimmerWidget.rounded(
              height: config.appHeight(12),
              width: double.maxFinite,
              borderRadius: 5,
            ),
          ),
          Row(
            children: List.generate(
              3,
              (index) => Expanded(
                child: Padding(
                  padding: EdgeInsets.all(config.appHorizontalPaddingSmall()),
                  child: ShimmerWidget.rounded(
                    height: config.appHeight(6),
                    width: double.maxFinite,
                    borderRadius: 5,
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: List.generate(
              3,
              (index) => Padding(
                padding: EdgeInsets.all(config.appHorizontalPaddingSmall()),
                child: ShimmerWidget.rounded(
                  height: config.appHeight(15),
                  width: double.maxFinite,
                  borderRadius: 5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ColumnShimmer extends StatelessWidget {
  const ColumnShimmer({super.key, required this.config, this.height});
  final SizeConfig config;
  final double? height;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(5, (index) {
        return Padding(
          padding: EdgeInsets.all(config.appHorizontalPaddingMedium()),
          child: ShimmerWidget.rounded(
            height: height ?? config.appHeight(16),
            width: double.maxFinite,
            borderRadius: 5,
          ),
        );
      }),
    );
  }
}
