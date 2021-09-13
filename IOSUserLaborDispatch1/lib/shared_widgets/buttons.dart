import '../configs/app_colors.dart';
import 'package:flutter/material.dart';

class buttonWidget extends StatelessWidget {
  final String btnText;
  final String fontFamily;
  final double radius;
  final double height;
  final double width;
  final double btnTextSize;
  final Function onPressed;
  final double letterSpacing;
  final Color btnColor;
  final Color btnTextColor;

  const
  buttonWidget({
    Key key,
    this.btnText,
    this.height = 50,
    this.width = 130,
    this.radius = 0,
    this.letterSpacing = 0,
    this.onPressed,
    this.fontFamily = 'Montserrat',
    this.btnColor = AppColors.APP_PRIMARY_COLOR,
    this.btnTextColor = Colors.white,
    this.btnTextSize = 14,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Align(
        alignment: Alignment.center,
        child: Container(
        height: height,
        width: width,
        child: RaisedButton(
            disabledColor: btnColor,
            onPressed: onPressed,
            textColor: btnTextColor,
            // shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(radius)),
            color: btnColor,
            child: Text(
              btnText,
              textAlign: TextAlign.center,
              style: TextStyle(
                // fontWeight: FontWeight.bold,
                  fontFamily: fontFamily,
                  letterSpacing: letterSpacing,
                  fontSize: btnTextSize,
                  color: btnTextColor),
            )
        ))
    );
  }
}
