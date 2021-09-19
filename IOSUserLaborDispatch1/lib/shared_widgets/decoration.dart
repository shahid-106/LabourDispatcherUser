import '../configs/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DecorationBoxes {

  static BoxDecoration decorationGradientWithCircle() {
    return const BoxDecoration(
        // gradient: RadialGradient(
        //   colors: [AppColors.APP_SECONDARY_COLOR, AppColors.APP_PRIMARY_COLOR],
        // ),
        color: AppColors.APP_PRIMARY_COLOR,
        shape: BoxShape.circle);
  }

  static BoxDecoration decorationRoundBottomContainer() {
    return BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(20.0),
          topRight: const Radius.circular(20.0),
        ));
  }

  static BoxDecoration decorationRoundTopWithRadius({Color color, double radius}) {
    return BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: new BorderRadius.only(
          topLeft: Radius.circular(radius ?? 20.0),
          topRight: Radius.circular(radius ?? 20.0),
        ));
  }

  static BoxDecoration decorationBackgroundWithBottomRadius({Color color}) {
    return BoxDecoration(
        color: color??AppColors.APP_GREY_COLOR.withOpacity(0.15),
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(20.0),
          bottomLeft: Radius.circular(20.0),
        ),
      boxShadow: [
        BoxShadow(
          color: Colors.grey,//.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 10,
          offset: const Offset(1, 0), // changes position of shadow
        ),
      ],
    );
  }

  static BoxDecoration decorationBackgroundGreyWithRadius() {
    return BoxDecoration(
      color: AppColors.APP_GREY_COLOR.withOpacity(0.18),
      borderRadius: BorderRadius.all(Radius.circular(30.0)),
    );
  }

  static BoxDecoration decorationWithRadiusAll(Color color, {double radius}) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.all(Radius.circular(radius ?? 10.0)),
    );
  }

  static BoxDecoration decorationWithRadiusAllAndBorderColor(
      Color color, Color borderColor,
      {double radius}) {
    return BoxDecoration(
      color: color,
      border: Border.all(width: 1.00, color: borderColor),
      borderRadius: BorderRadius.all(Radius.circular(radius ?? 10.0)),
    );
  }

  static BoxDecoration decorationSquareWithShadow() {
    return BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      boxShadow: [
        BoxShadow(
          color: AppColors.APP_WHITE_COLOR,//.withOpacity(0.6),
          // spreadRadius: 5,
          // blurRadius: 12,
          // offset: Offset(0, 2), // changes position of shadow
        ),
      ],
    );
  }

  static BoxDecoration decorationSquareWithoutShadowWithNormalRadius() {
    return BoxDecoration(
      color: Color(0xffFFFFFF),
      border: Border.all(
        width: 2.00,
        color: AppColors.APP_GREY_COLOR,
      ),
      borderRadius: BorderRadius.circular(15.00),
    );
  }

  static BoxDecoration decorationSquareWithShadowWithNormalRadius({Color color}) {
    return BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 2,
          blurRadius: 3,
          offset: Offset(0, 0), // changes position of shadow
        ),
      ],
      color: color??Color(0xffFFFFFF),
      border: Border.all(
        width: 1.00,
        color: Color(0xffFFFFFF),
      ),
      borderRadius: BorderRadius.circular(20.00),
    );
  }

  static BoxDecoration decorationSquareWithShadowWithMinRadius() {
    return BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 2,
          blurRadius: 3,
          offset: Offset(0, 0), // changes position of shadow
        ),
      ],
      color: Color(0xffFFFFFF),
      border: Border.all(
        width: 2.00,
        color: Color(0xffFFFFFF),
      ),
      borderRadius: BorderRadius.circular(10.00),
    );
  }

  static BoxDecoration decorationWhiteAllBorder({double radius}) {
    return BoxDecoration(
      color: AppColors.APP_WHITE_COLOR,
      border: Border.all(
        width: 1.00,
        color: AppColors.APP_WHITE_COLOR,
      ),
      borderRadius: BorderRadius.circular(radius ?? 15.00),
    );
  }

  static BoxDecoration decorationGreyAllBorder({double radius}) {
    return BoxDecoration(
      color: Colors.grey.shade300,
      borderRadius: BorderRadius.circular(radius ?? 15.00),
    );
  }

  static BoxDecoration decorationTopBorder() {
    return BoxDecoration(
      border: Border.all(
        width: 1.00,
        color: AppColors.APP_GREY_COLOR,
      ),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10.0),
        topRight: Radius.circular(10.0),
        bottomLeft: Radius.zero,
        bottomRight: Radius.zero,
      ),
    );
  }

  static BoxDecoration decorationBottomBorder() {
    return BoxDecoration(
      border: Border(
        bottom: BorderSide(width: 1.0, color: AppColors.APP_WHITE_COLOR),
      ),
    );
  }
}

class DecorationInputs {
  static InputDecoration textBoxInputDecoration({String label}) {
    return InputDecoration(
      isDense: true,
      hintText: label??'',
      // hintStyle: TextStyle(fontFamily: 'Montserrat', color: AppColors.APP_PINK_COLOR, fontSize: 12),
      contentPadding: EdgeInsets.fromLTRB(0, 10, 10, 10),
      errorBorder: UnderlineInputBorder(
          // borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.APP_RED_COLOR)),
      // enabledBorder: UnderlineInputBorder(
      //     borderRadius: BorderRadius.circular(15),
      //     borderSide:
      //         BorderSide(color: AppColors.APP_PINK_COLOR, width: 1.0)),
      // focusedBorder: UnderlineInputBorder(
      //   borderSide: BorderSide(color: Colors.cyan),
      // ),
      focusedBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: AppColors.APP_PINK_COLOR)),
    );
  }

  static InputDecoration textBoxInputDecorationWithPrefixIcon(
      {String labelText, Icon prefixIcon}) {
    return InputDecoration(
        isDense: true,
        // border: InputBorder.none,
        hintText: labelText??'',
        hintStyle: TextStyle(color: AppColors.APP_WHITE_COLOR, fontSize: 16),
        contentPadding: EdgeInsets.fromLTRB(10, 15, 10, 10),
        errorBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide:
            BorderSide(color: AppColors.APP_RED_COLOR, width: 1.0)),
        enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide:
            BorderSide(color: AppColors.APP_WHITE_COLOR, width: 1.0)),
        focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide:
            BorderSide(color: AppColors.APP_WHITE_COLOR, width: 1.0)),
        prefixIcon: prefixIcon);
  }

  static InputDecoration textboxInputDecorationWithPrefixAndSuffixIcon(
      {String labelText, Widget prefix, Widget suffix}) {
    return InputDecoration(
        border: InputBorder.none,
        labelText: labelText,
        contentPadding: const EdgeInsets.all(10.0),
        labelStyle: TextStyle(
          color: Colors.grey,
        ),
        errorBorder: new UnderlineInputBorder(
          borderSide: new BorderSide(color: Colors.red, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        prefixIcon: prefix,
        suffixIcon: suffix);
  }

  static InputDecoration textboxInputDecorationWithSuffixIcon(
      {String labelText, IconButton suffixIcon}) {
    return InputDecoration(
      //border: InputBorder.none,
      labelText: labelText,
      contentPadding: const EdgeInsets.all(10.0),
      labelStyle: TextStyle(
        color: Colors.grey,
      ),
      errorBorder: new UnderlineInputBorder(
        borderSide: new BorderSide(color: Colors.red, width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      suffixIcon: suffixIcon,
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.APP_GREY_COLOR,
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: AppColors.APP_PRIMARY_COLOR, width: 2.0)),
    );
  }
}
