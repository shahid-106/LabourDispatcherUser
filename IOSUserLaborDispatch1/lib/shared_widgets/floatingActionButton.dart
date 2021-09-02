import '../configs/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FloatingActionBtn extends StatelessWidget {
  final String label;
  final Function onTap;
  final Widget image;

  FloatingActionBtn({this.label, this.onTap, this.image});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onTap,
      label: Text(label),
      icon: image??Icon(Icons.add_circle),
      backgroundColor: AppColors.APP_PRIMARY_COLOR,
    );
  }
}
