import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../resources/size_config.dart';

// This widget is for screen component (item/widget) build
class BaseWidget extends StatelessWidget {
  final Widget Function(
      BuildContext context, SizeConfig config, ThemeData themeData) builder;

  const BaseWidget({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    final config = SizeConfig(context);
    final themeData = Theme.of(context);
    return builder(context, config, themeData);
  }
}

/// base hook widget class for hook based shared,
///
/// provides same information as BaseWidget provides like (theme, sizeConfig
class HookBaseWidget extends HookWidget {
  final Widget Function(
      BuildContext context, SizeConfig config, ThemeData themeData) builder;

  const HookBaseWidget({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    final config = SizeConfig(context);
    final themeData = Theme.of(context);
    return builder(context, config, themeData);
  }
}
