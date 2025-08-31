import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../resources/export_resources.dart';

class CustomSmartRefresher extends StatelessWidget {
  const CustomSmartRefresher({
    super.key,
    required this.controller,
    this.onRefreshing,
    this.onLoading,
    this.enablePullUp,
    this.enablePullDown,
    this.header,
    required this.child,
  });
  final RefreshController controller;
  final VoidCallback? onRefreshing;
  final VoidCallback? onLoading;
  final bool? enablePullUp;
  final bool? enablePullDown;
  final Widget? header;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullUp: enablePullUp ?? false,
      enablePullDown: enablePullDown ?? false,
      header: header ?? WaterDropMaterialHeader(backgroundColor: whiteColor, color: primaryColor, ),
      controller: controller,
      onLoading: onLoading,
      onRefresh: onRefreshing,
      child: child,
    );
  }
}
