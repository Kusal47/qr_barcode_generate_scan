import 'package:flutter/material.dart';

import '../../constants/validators.dart';
import '../../resources/export_resources.dart';
import '../export_common_widget.dart';

class MenuAnchorDropDown<T> extends StatefulWidget {
  const MenuAnchorDropDown({
    super.key,
    required this.hintText,
    required this.items,
    required this.label,
    this.textcontroller,
    this.onSelected,
    this.itemToString,
    this.itemToIcon,
    this.validator,
    this.isNetworkTable = false,
    this.textFontSize,
    this.enabled = false,
    this.isFilled = false,
    this.prefixIcon,
  });

  final String hintText;
  final List<T> items;
  final String label;
  final TextEditingController? textcontroller;
  final ValueChanged<T>? onSelected;
  final String Function(T)? itemToString;
  final String Function(T)? itemToIcon;
  final String? Function(String?)? validator;
  final bool? isNetworkTable;
  final double? textFontSize;
  final bool? enabled;
  final bool? isFilled;

  final Widget? prefixIcon;

  @override
  State<MenuAnchorDropDown<T>> createState() => _MenuAnchorDropDownState<T>();
}

class _MenuAnchorDropDownState<T> extends State<MenuAnchorDropDown<T>> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return MenuAnchor(
      style: MenuStyle(backgroundColor: MaterialStateProperty.all(whiteColor)),
      builder: (BuildContext context, MenuController controller, Widget? child) {
        return GestureDetector(
          onTap: () {
            widget.items.isNotEmpty && widget.enabled == false ? controller.open() : null;
          },
          child: PrimaryFormField(
            onSaved: (p0) {},
            prefixIcon: widget.prefixIcon,
            isFilled: widget.isFilled!,
            controller: widget.textcontroller,
            validator: widget.validator ?? Validators.checkDropdownField,
            enabled: false,
            readOnly: widget.enabled,
            title: widget.label,
            hintTxt: widget.hintText,
            suffixIcon:
                widget.items.isNotEmpty && widget.enabled == false
                    ? Icon(
                      Icons.arrow_drop_down_outlined,
                      color:
                          Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                      size: size.height * 0.03,
                    )
                    : null,
          ),
        );
      },
      menuChildren:
          widget.items.map((T item) {
            return MenuItemButton(
              autofocus: true,
              onPressed: () {
                setState(() {
                  if (widget.onSelected != null) {
                    widget.onSelected!(item);
                  }
                  if (widget.itemToString != null) {
                    widget.textcontroller?.text = widget.itemToString!(item);
                  } else {
                    widget.textcontroller?.text = item.toString();
                  }
                });
              },
              child: Row(
                children: [
                  widget.itemToIcon != null && widget.itemToIcon!(item).isNotEmpty
                      ? Container(
                        height: size.height * 0.03,
                        width: size.height * 0.04,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(widget.itemToIcon!(item)),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      )
                      : const SizedBox.shrink(),
                  SizedBox(width: size.width * 0.01),
                  Text(
                    widget.itemToString != null ? widget.itemToString!(item) : item.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: size.height * 0.02,
                      color: blackColor,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }
}
