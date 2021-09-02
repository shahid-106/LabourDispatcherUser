import '../configs/app_colors.dart';
import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  final int index;

  Indicator(this.index);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return circle(index + 1);
        });
  }

  Widget circle(int digit) {
    return Container(
      margin: EdgeInsets.all(5),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        border: Border.all(width: 0.5, color: AppColors.APP_PRIMARY_COLOR),
        shape: BoxShape.circle,
        color: digit == index ? AppColors.APP_PRIMARY_COLOR : Colors.white,
      ),
      child: null,
    );
  }
}
