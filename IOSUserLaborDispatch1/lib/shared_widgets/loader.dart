import '../configs/app_colors.dart';
import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  Color color;

  Loader({this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(
                AppColors.APP_PRIMARY_COLOR)));
  }
}
