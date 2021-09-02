import 'package:flutter/material.dart';

class DropDownField extends StatelessWidget {
  final String title;
  final String hintText;
  final value;
  final List collection;
  final Function onChanged;
  final Function onTapSuffixIcon;
  final Function onTapPrefixIcon;
  final IconData suffixIconData;
  final IconData prefixIconData;
  final Color backgrounColor;
  final Color dropDownColor;
  final Color hintTextColor;
  final Color prefixIconColor;
  final Color sufixIconColor;
  final Color valueColor;
  final Color defaultIconColor;

  final BorderSide borderSide;

  const DropDownField({
    Key key,
    this.title,
    this.value,
    this.collection,
    this.onChanged,
    this.hintText,
    this.prefixIconData,
    this.onTapSuffixIcon,
    this.onTapPrefixIcon,
    this.suffixIconData,
    this.dropDownColor,
    this.valueColor = Colors.white,
    this.hintTextColor = Colors.white,
    this.prefixIconColor = Colors.white,
    this.sufixIconColor = Colors.white,
    this.backgrounColor,
    this.defaultIconColor = Colors.white,
    this.borderSide,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
          color: this.backgrounColor ?? Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(4)),
      child: DropdownButtonFormField(
        value: value,
        style: Theme.of(context).textTheme.bodyText2.copyWith(
              color: valueColor,
            ),
        dropdownColor: dropDownColor ?? Colors.black.withOpacity(0.9),
        iconEnabledColor: defaultIconColor,
        decoration: InputDecoration(
            labelText: title,
            labelStyle: Theme.of(context).textTheme.bodyText2,
            hintText: hintText,
            hintStyle: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(fontWeight: FontWeight.w300, color: hintTextColor),
            prefixIcon: prefixIconData == null
                ? null
                : GestureDetector(
                    onTap: onTapPrefixIcon,
                    child: Icon(
                      prefixIconData,
                      color: prefixIconColor,
                    ),
                  ),
            suffixIcon: suffixIconData == null
                ? null
                : GestureDetector(
                    onTap: onTapSuffixIcon,
                    child: Icon(
                      suffixIconData,
                      color: sufixIconColor,
                    ),
                  ),
            contentPadding: EdgeInsets.only(left: 16, right: 8),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: borderSide ?? BorderSide.none),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: borderSide ?? BorderSide.none)),
        items: collection.map<DropdownMenuItem>((value) {
          return DropdownMenuItem(value: value, child: Text(value.toString()));
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
