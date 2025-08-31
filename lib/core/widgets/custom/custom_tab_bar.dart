import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../resources/colors.dart';
import '../../resources/size_config.dart';
import 'custom_widget.dart';

class CustomTabBar extends StatefulWidget {
  final SizeConfig config;
  final List<String> tabs;
  final List<IconData>? prefixImages;
  final TabController? controller;
  final Function(int index)? onTap;
  final int? pendingItemCount;
  final Color? labelStyleColor;
  final Color? unselectedLabelStyleColor;
  final Color? indicatorColor;
  final double? indicatorWeight;
  final Color? dividerColor;
  final double? dividerHeight;
  final bool? isScrollable;
  final double? labelFontSize;
  final FontWeight? labelFontWeight;
  final EdgeInsetsGeometry? tabItemPadding;

  const CustomTabBar({
    super.key,
    required this.config,
    required this.tabs,
    this.prefixImages,
    this.controller,
    this.onTap,
    this.pendingItemCount,
    this.labelStyleColor,
    this.unselectedLabelStyleColor,
    this.indicatorColor,
    this.indicatorWeight,
    this.dividerColor,
    this.dividerHeight,
    this.isScrollable = false,
    this.labelFontSize,
    this.labelFontWeight,
    this.tabItemPadding,
  });

  @override
  _CustomTabBarState createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onTabChanged);
    super.dispose();
  }

  void _onTabChanged() {
    if (mounted) {
      setState(() {
        selectedIndex = widget.controller?.index ?? 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      onTap: (index) {
        widget.onTap?.call(index);
        setState(() {
          selectedIndex = index;
        });
      },

      controller: widget.controller,
      dividerColor: widget.dividerColor ?? transparent,
      dividerHeight: widget.dividerHeight ?? 0.0,
      indicatorSize: TabBarIndicatorSize.label,
      tabAlignment: widget.isScrollable == true ? TabAlignment.start : null,
      dragStartBehavior: DragStartBehavior.start,
      isScrollable: widget.isScrollable!,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      indicatorWeight: widget.indicatorWeight ?? 1,
      labelStyle: customTextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: widget.labelStyleColor ?? whiteColor,
      ),
      unselectedLabelStyle: customTextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: widget.unselectedLabelStyleColor ?? whiteColor,
      ),
      indicatorColor: widget.indicatorColor ?? primaryColor,
      tabs:
          widget.tabs.asMap().entries.map((entry) {
            int index = entry.key;
            String tabText = entry.value;
            bool isSelected = index == selectedIndex;

            return Tab(
              child: Container(
                padding: widget.tabItemPadding??EdgeInsets.symmetric(
                  horizontal: widget.config.appHorizontalPaddingMedium(),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if(widget.prefixImages != null)...[
Icon(
                          widget.prefixImages![index],
                          size: widget.config.appHeight(3),
                          color: isSelected ? primaryColor : darkGreyColor,
                        ),
                    widget.config.horizontalSpaceSmall(),
                    ],
                        
                    Text(
                      tabText,
                      style: customTextStyle(
                        fontSize: widget.labelFontSize ?? widget.config.appHeight(1.8),
                        fontWeight: widget.labelFontWeight ?? FontWeight.normal,
                        color:
                            isSelected
                                ? widget.labelStyleColor ?? primaryColor
                                : widget.unselectedLabelStyleColor ?? blackColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }
}
