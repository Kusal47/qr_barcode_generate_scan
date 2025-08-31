import 'package:flutter/material.dart';

import '../../resources/ui_assets.dart';

class ShimmerWidget {
  static Widget rounded({double? width, double? height, double? borderRadius}) => _RoundedShimmer(
        borderRadius: borderRadius,
        width: width,
        height: height,
      );

  static Widget circular({double? radius}) => _CircularShimmer(
        radius: radius,
      );
}

class _CircularShimmer extends StatelessWidget {
  final double? radius;

  const _CircularShimmer({
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius ?? 30,
      backgroundImage: const AssetImage(UiAssets.shimmerLoading),
    );
  }
}

class _RoundedShimmer extends StatelessWidget {
  final double? width;
  final double? height;
  final double? borderRadius;

  const _RoundedShimmer({this.width, this.height, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 50,
      height: height ?? 50,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? 8),
        child: Image.asset(UiAssets.shimmerLoading, fit: BoxFit.cover),
      ),
    );
  }
}
